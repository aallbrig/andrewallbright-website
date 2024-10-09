---
title: Restoring My Website using IaC
author: Andrew Allbright
type: post
date: 2023-11-06T13:00:00+00:00
url: /transforming-my-website-from-ad-box-manual-operations-into-iac-using-terraform-and-cloudformation/
categories:
  - Game Programming

---
This very website faces a prolonged period of inactivity. I must admit that there appeared an error that I wasn’t able to resolve. Allow me to describe my previous setup so that you can understand the transformation.

I once had a desire to create a website for myself. I wanted to create a space on the internet to call my own. Previously I had created WordPress websites for others; surely I could create one for myself.

Initially I explored shared hosting solutions. I then yearned for more practical experiences. Surly I was programmer enough to arrange a WordPress website on top of AWS.

Originally I wanted something more complex complete with a CICD pipeline and especially IaC. I settle on configuring everything through the AWS web GUI. The advertised happy path, in a lot of ways.

Everything worked! Until it didn’t. I set up automatic updates. Who knows what exactly the misconfiguration was. At the end of the day my website would regularly (and daily) become unusable. Manually restarting the instance upon detection temporarily resolved the issue. I set up a CRON to reset the instance daily.

For a long time I knew I needed to encode my admin actions into infrastructure as code (IaC) using technologies like cloud formation (cf) and/or terraform (tf). Personally I like writing tf programs that orchestrate cf templates. I should try cf “master” templates that afford the same orchestration feature but I will observe that I like the simplicity of hydrating a tf AWS resource using the returned resource ID/ARN that I suspect would be a bit harder to achieve using strictly cf template(s). I’m sure I’ll soon experiment to discover which workflow works well for me.

The restoration of this website to owed to the combined technologies of terraform and cloud formation. I indeed use tf to orchestrate cf templates. I suppose one could argue that my solution is overkill for the size of audience my website receives. I would retort that this website serves as a documented piece that proves a level of competence building on top of AWS as a platform.

To describe my setup I will behind at the domain. AWS route 53 (r53) serves a hosted zone where all my domain records are configure for andrewallbright.com. The apex A record points to an AWS CloudFront distribution, a content distribution network (CDN) solution offered by the platform. The distribution points to an application load balancer (ALB) whose target group points to a collection of EC2 instances.

These instances are located in a /27 (CIDR notation) IP space. Right now they are Amazon Linux 2023 whose primary change is from using yum package manager to using dnf package manager.

Setting up a WordPress enabled instance is a combination of using user data scripts to configure the instance with appropriate packages to serve WordPress website traffic but also use WordPress CLI to make common configuration of my website. Now I have a place I can reference to recall the theme I use and the plug-in dependencies to make my website function.

Getting experience with defining “principle of least privilege” policies and roles is an active aspect of restoring my website. For some reason grokking AWS roles and policies served as a roadblock for me. I chalk it up to being a topic that hands on experience refines understanding. Anyways, I followed this principle while I defined network access lists (nacls), security groups (sgs), policies and roles (serving to be a composition of different context relevant policies).

Furthermore I want to point out that I keep my configuration data in Parameter Store and my secret data in Secrets Store. These are shared with my WordPress instances.

Secure communications is important to me. Right now I have AWS Key Management Storage (KMS) hosting AWS managed certificates. One is for my CloudFront distribution, another is for my ALB. SSL termination occurs from ALB to EC2 but this is an identified area of improvement if I wanted to implement end to end “encryption in transit” characteristics for my website (I’ve already identified certbot CLI as a means of accomplishing this).

Overall I’m very happy I’ve been able to restore this website’s functionality. I feel I’ve been able to lay a good foundation to expand my website’s capabilities on. Most of all I’m happy I’m back to writing about my programmer experiences again for an audience. Let me know what you think: is my architecture overkill? Would you design such a solution for a website with such a low audience (for now)? Share your thoughts please!