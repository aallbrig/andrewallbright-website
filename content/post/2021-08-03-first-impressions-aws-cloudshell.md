---
title: 'First Impressions: AWS CloudShell'
author: Andrew Allbright
type: post
date: 2021-08-03T17:56:32+00:00
url: /first-impressions-aws-cloudshell/
categories:
  - Software Engineering

---
I remember seeing an announcement about [AWS Cloud Shell][1] December of 2020 but I did not explore it then. Instead I was focusing on my Unity learning path. Recently, I decided to use it when I had to fix the state of my AWS resources. This blog is meant to capture some of my thoughts and excitement.

I use Electronic Freedom Foundation (EFF)&#8217;s [Certbot][2] tool to handle SSL certification rotation ([How does SSL work? by CloudFlare][3], for the curious) directly on my AWS [EC2 instances][4]. With my current setup, I need to intervene every so often (not great but good enough). This was what provided me the opportunity to explore AWS CloudShell months after its release.

AWS CloudShell gives users access to a shell in a browser that is already configured to work with AWS. Before CloudShell programmers would have to configure a shell on their computer to use any type of command-line interface (CLI). CloudShell comes with useful software preinstalled and my favorite is the AWS CLI.

This reduction in friction is very exciting. I know some people in my life I&#8217;m excited to share AWS commands with.

I am looking forward to see how third party documentation will change for technology projects like [Mirror Networking][5] to have easy to run instructions when running that technology on AWS. Specifically, the &#8216;[server hosting on aws][6]&#8216; page on Mirror Networking contains instructions on using the GUI web interface, which makes the task seem daunting in my opinion. This can be replaced with instructions of using the AWS CLI which will make the instructions clearer and more terse (which I think is more readable).

As an programmer with quite a few computers and laptops I am pleased to know I have the option to use AWS CloudShell if I don&#8217;t feel inclined to configure my machine&#8217;s shell.

Considering how software is only interesting when it is publicly available, I rejoice at the reduction of &#8216;configure your host&#8217; time, allowing project time to be spent on the project code itself.

 [1]: https://aws.amazon.com/cloudshell/
 [2]: https://certbot.eff.org/
 [3]: https://www.cloudflare.com/learning/ssl/how-does-ssl-work/
 [4]: https://aws.amazon.com/ec2
 [5]: https://mirror-networking.com/
 [6]: https://mirror-networking.gitbook.io/docs/guides/server-hosting/aws