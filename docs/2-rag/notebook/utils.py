#!/usr/bin/env python3
from pathlib import Path
import sys

def project_root() -> Path:
    """
    Return a reliable base directory for relative paths.

    • If the program is a script (so __file__ exists), use the script’s parent folder.  
    • If it’s running in an interactive session or notebook where __file__ is absent,
      fall back to the current working directory.
    """
    main_mod = sys.modules.get('__main__')
    if getattr(main_mod, '__file__', None):
        return Path(main_mod.__file__).resolve().parent
    return Path.cwd()

import requests
from io import BytesIO
from urllib.parse import urlparse
import os

def download_source_docs(s3, bucket_name, file_urls):
    """
    Downloads PDF files from provided URLs and uploads them to the specified MinIO bucket.

    :param s3: boto3 S3 client
    :param bucket_name: Name of the destination S3 bucket
    :param file_urls: List of raw GitHub URLs pointing to PDF files
    """
    print(f"INFO: download_source_docs()")
    
    validate_bucket(s3,bucket_name)                          # Make sure the bucket exists
    
    for url in file_urls:
        try:
            # Derive object key from URL path
            parsed_url = urlparse(url)
            object_key = os.path.basename(parsed_url.path)

            print(f"⬇️ Downloading: {url}")
            response = requests.get(url)
            response.raise_for_status()

            print(f"⬆️ Uploading: {object_key} to bucket {bucket_name}")
            s3.upload_fileobj(
                Fileobj=BytesIO(response.content),
                Bucket=bucket_name,
                Key=object_key,
                ExtraArgs={"ContentType": "application/pdf"}
            )
            print(f"🟢 Uploaded '{object_key}' successfully.")

        except requests.HTTPError as http_err:
            print(f"🔴 HTTP error downloading {url}: {http_err}")
            raise
        except (BotoCoreError, ClientError) as s3_err:
            print(f"🔴 S3 upload failed for {url}: {s3_err}")
            raise


from botocore.exceptions import ClientError, BotoCoreError

def validate_bucket(s3, bucket_name):
    """
    Check that the bucket exists. If not, create it..

    :param s3: boto3 S3 client
    :param bucket_name: Name of the destination S3 bucket
    """ 
    
    print(f"INFO: validate_bucket()")
    
    # Ensure the bucket exists
    try:
        s3.head_bucket(Bucket=bucket_name)
        print(f"🪣 Bucket '{bucket_name}' exists.")
    except ClientError as e:
        error_code = int(e.response["Error"]["Code"])
        if error_code == 404:
            print(f"🪣 Bucket '{bucket_name}' not found. Creating it...")
            s3.create_bucket(Bucket=bucket_name)
            print(f"✅ Bucket '{bucket_name}' created.")
        else:
            print(f"🔴 Error checking bucket: {e}")
            raise

def delete_bucket(s3, bucket_name):
    """
    Delete a bucket and its contents.

    :param s3: boto3 S3 client
    :param bucket_name: Name of the destination S3 bucket
    """ 
    try:
        print(f"🧹 Deleting all objects in bucket '{bucket_name}'...")
        resp = s3.list_objects_v2(Bucket=bucket_name)
        for obj in resp.get("Contents", []):
            s3.delete_object(Bucket=bucket_name, Key=obj["Key"])
            print(f"❌ Deleted: {obj['Key']}")

        print(f"🪣 Deleting bucket '{bucket_name}'...")
        s3.delete_bucket(Bucket=bucket_name)
        print(f"✅ Bucket '{bucket_name}' deleted.")
    except (BotoCoreError, ClientError) as err:
        print(f"🔴 Failed to delete bucket or objects: {err}")
        raise