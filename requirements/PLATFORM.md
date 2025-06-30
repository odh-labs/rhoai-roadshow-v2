# Platform Engineering for Red Hat AI

## Why do we care ?

Red Hat's core strength is the ability to ship and support products that are used by our customers to build *their application platform* and customer experience upon. We do this across any cloud and any infrastructure. The narrative and goal of Red Hat in AI is to do exactly what we have dome first for linux, then for containers and now for AI.

Bringing AI to your customers and your business layer applications is a journey. It may start with Chatbots, or enhanced knowledge search using RAG, however the future will likely be Agentic AI systems that can interact to suit your needs and solve your business problems.

This requires a platform. And for Red Hat AI - this could be RHEL AI, Red Hat OpenShift AI or standalone Red Hat AI Inference Server. You will need to be *this tall* to be able to run AI on a platform that will get you to production and back to BAU.

## What is it ?

It is unlikely we can cover all of the 3 platforms in detail in the roadshow as they are distinct product offerings. Let's concentrate on RHOAI as it is the go-to platform for container based application developers, the most feature rich and will be the basis for Agentic AI.

I would summarize the goals of Platform Engineering as follows:

**build the minimum viable platform** - we bring just enough of the platform to meet our business goals. For example, perhaps we are only interested in running jupyter notebooks as a service for our Data Scientists - we may not need to deploy all of the other bits and pieces to achieve this goal.

**create consistent environments** - a key goal is to deliver environments that are similar in configuration and management. One of the reasons for setting up different environments is so we can safely bring software to production. We can build and test safely without affecting out end customer's business services. To do this, our environments cannot be *snowflakes* or so individually different that they don't look anything like each other.

**practice everything as code** - just like we develop applications using software, we deploy infrastructure as code and our platforms as code. This makes them anti-fragile since we can always check git for what exactly is configured and deployed. Source code management systems like git can be audited, traced and shared - so by ensuring everything is managed as code ultimately brings about far superior quality of service.

**no fantasy cruises** - ultimately software has no value until it gets to production i.e. it serves our customers as a business application or service. But you not only have to have good enough quality and release control to get to production, you need to be able to build and maintain software and configuration as part of business as usual (BAU). Ideally you adopt CI/CD practices as well as platform SRE practices, managing your work with error budgets and bake in the ability to fully observe your applications and platforms in real-time.

## How do we do it ?

The good news is we can manage our AI platform exactly the same as we manage our Red Hat OpenShift / Kubernetes environments. Whilst there may be a tonne of new tech involved in GenAI, the tooling we use and the methodologies we adopt can remain consistent.

**ACM + ACS + OCP** - there is a fantastic reason we package up these 3 products as "OpenShift Plus (OPP)". They form the basis for your "minimum viable platform" to get you to production and back to BAU safely. Let's break it down a little bit.

**Policy as Code** - Policies are one key way that organizations ensure software is high quality, easy to use, and secure. Manual reviews are one method to check software is compliant, but they are time-consuming, error-prone, and impossible to scale. Policy as code (PaC) automates this decision-making process by codifying and enforcing policies. It can be used to automate validation procedures to control and manage infrastructure. 

**Zero configuration drift** - We use ACM + Policy + PolicyGenerator to create all infraops code as policy. This scales out to all of our clusters across our environments. The SRE can go to the Governance dashboard and immediately see if any drift has occurred e.g. errors on mis-applied policies.

**GitOps** - We use ArgoCD / OpenShift GitOps to deliver our policy + configuration in a consistent way. We have a saying when using GitOps as a practice - that if _"it's not in git, it is not real"_. The best part about GitOps is it works in conjunction with how we deliver infrastructure applications using the Operator pattern. With OLMv1 being rolled out - we be able to fully manage and control operators with GitOps.

**Baseline Security and Compliance** - When we deploy clusters, they immediately join ACS as secured clusters and apply any configuration changes that are needed to meet our baseline compliance standards. Security is built in from the start and we can then start practicing moving security "left" into our CI/CD pipelines as we build, test and deliver our applications and infrastructure.

## Roadshow workshop narrative

Hands-on lab

- Learn how to setup and configure a RHOAI environment using GitOps and Policies
- Learn how to scale out the environment
- Learn how to modify and lifecycle manage the platform
- Learn how to observe and measure baseline compliance and security
