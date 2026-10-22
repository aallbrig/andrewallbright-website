---
title: About
slug: about
excerpt: Andrew Allbright's home page, with the technologies he works with grouped by area and linked to their documentation.
wp_post_id: 8
---

My name is Andrew Allbright. I work with computers and I really love programming. Welcome to my little spot on the web. Take a look around. Let me know what you think. I do enjoy reading observations or answering questions.

---

## Latest Blog Post

<!-- wp:latest-posts {"postsToShow":1,"displayPostContent":true,"excerptLength":32,"displayPostDate":true} /-->

---

## Technologies

Here are the technologies I work with, grouped by area. Every row links to the official documentation or manual, so treat this page as a jumping-off point.
The briefs are my own notes. This is a non-exhaustive list.

### Programming languages

| Language | Brief | Docs |
|----------|-------|------|
| Go | Experienced. Default scripting language when shell scripting isn't enough. #devops #kubernetes #CLIs | [docs](https://go.dev/doc/) |
| Python | Experienced. A fantastic scripting language with a lot of punch. #flask #django #pygame #CLIs | [docs](https://docs.python.org/3/) |
| JavaScript | Experienced. | [MDN docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript) |
| TypeScript | Experienced. Championed its adoption on a front-end architecture guild. | [docs](https://www.typescriptlang.org/docs/) |
| Node.js | Experienced. Co-led the Indianapolis Node.js meetup. | [docs](https://nodejs.org/en/docs/) |
| C# and .NET | Experienced. Modernized legacy REST and SOAP APIs at work, and it is the language of my Unity games. | [C# docs](https://learn.microsoft.com/en-us/dotnet/csharp/), [.NET docs](https://learn.microsoft.com/en-us/dotnet/) |
| Scala | Experienced. From command line apps to Scala Play microservice applications I can create, maintain, and operate within this runtime. #restAPIs #CLIs #functional-programming | [docs](https://docs.scala-lang.org/), [Play](https://www.playframework.com/documentation) |
| Java and the JVM | The runtime underneath Scala. | [docs](https://docs.oracle.com/en/java/) |
| PHP | Experienced. Good to know because shared hosting platforms like GoDaddy and Dreamhost support it. Great for simple projects and for WordPress. | [docs](https://www.php.net/docs.php) |
| GDScript | Godot's Python-like scripting language, used in my Godot game prototypes. | [docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) |
| Bash | Experienced. #linux #containers #shell-scripting | [manual](https://www.gnu.org/software/bash/manual/bash.html) |
| PowerShell | Scripting and packaging on Windows. | [docs](https://learn.microsoft.com/en-us/powershell/) |
| C and C++ | Firmware for Arduino and ESP32 boards. | [C and C++ reference](https://en.cppreference.com/) |

### Web and front end

| Technology | Brief | Docs |
|------------|-------|------|
| HTML5 | Experienced. #accessibility #graceful-degradation | [MDN docs](https://developer.mozilla.org/en-US/docs/Web/HTML) |
| CSS | Experienced. | [MDN docs](https://developer.mozilla.org/en-US/docs/Web/CSS) |
| Sass | Experienced. | [docs](https://sass-lang.com/documentation/syntax) |
| Less | Experienced. | [docs](https://lesscss.org/) |
| React and Redux | Built component-based UIs. | [React docs](https://react.dev/learn), [Redux docs](https://redux.js.org/introduction/getting-started) |
| Angular | Front-end framework from my time building consumer web apps. | [docs](https://angular.dev/overview) |
| Webpack | Experienced. | [docs](https://webpack.js.org/concepts/) |
| Web Push | Built a real-time message center with push notifications. | [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) |
| WebSockets | Real-time browser and server communication. #websockets | [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API) |
| Bootstrap | My default CSS framework for small sites. | [docs](https://getbootstrap.com/docs/) |
| Hugo | Static sites such as Stock Market Words and Anthem World. | [docs](https://gohugo.io/documentation/) |
| Eleventy | Static site generator behind Routine Mark. | [docs](https://www.11ty.dev/docs/) |
| WordPress | Runs this blog. I manage it with WP-CLI. | [docs](https://wordpress.org/documentation/), [developer handbook](https://developer.wordpress.org/), [WP-CLI](https://make.wordpress.org/cli/handbook/) |
| Playwright | End-to-end browser tests. | [docs](https://playwright.dev/docs/intro) |

### Cloud and infrastructure

| Technology | Brief | Docs |
|------------|-------|------|
| AWS | Experienced. I chose to invest my energy into AWS as my cloud provider of choice. I prefer the `aws` CLI. #cloud | [docs](https://docs.aws.amazon.com/), [CLI guide](https://docs.aws.amazon.com/cli/) |
| AWS CloudFormation | Infrastructure as code on AWS. See [Restoring My Website using IaC](https://andrewallbright.com/transforming-my-website-from-ad-box-manual-operations-into-iac-using-terraform-and-cloudformation/). | [docs](https://docs.aws.amazon.com/cloudformation/) |
| Amazon Route 53 | DNS for my domains. #ssl-certificates | [docs](https://docs.aws.amazon.com/route53/) |
| Amazon GameLift | Game server hosting. See [Techniques to Mitigate GameLift Anywhere's Odd Delays](https://andrewallbright.com/techniques-to-mitigate-gamelift-anywheres-odd-delays/). | [docs](https://aws.amazon.com/documentation-overview/gamelift/) |
| Google Cloud | A second cloud platform I have worked with. | [docs](https://cloud.google.com/docs) |
| Microsoft Azure | Cloud compute and virtual machines. | [docs](https://learn.microsoft.com/en-us/azure/) |
| Docker | Experienced. Ask me what I would do if an image wasn't building. Ask me how to develop inside a container. | [docs](https://docs.docker.com/) |
| Kubernetes | Experienced. Ask me how to remote debug an application running inside a cluster. #devops #YAML | [docs](https://kubernetes.io/docs/home/) |
| Helm | Packaging and progressive rollouts with Helm tests. | [docs](https://helm.sh/docs/) |
| Istio | Mutual TLS between Kubernetes workloads. | [docs](https://istio.io/latest/docs/) |
| Terraform | Beginner. | [docs](https://developer.hashicorp.com/terraform/docs) |
| Ansible | Experienced. Fantastic tool. #raspberry-pi #computer-setup #VMs | [docs](https://docs.ansible.com/) |
| Packer | Machine images for repeatable hosts. #images #portability | [docs](https://developer.hashicorp.com/packer/docs) |
| Linux | #kernel #system-calls #OS #fundamental | [kernel docs](https://docs.kernel.org/) |
| systemd | Services and timers on hosts and Raspberry Pis. | [docs](https://www.freedesktop.org/software/systemd/man/latest/) |
| Red Hat Enterprise Linux | Led a base container migration from CentOS to RHEL. | [docs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux) |

### CI/CD and developer tooling

| Technology | Brief | Docs |
|------------|-------|------|
| Git | Version control for everything. | [docs](https://git-scm.com/doc) |
| GitHub Actions | CI and deploys. See [Brand New Unity Project: My Starter Kit](https://andrewallbright.com/brand-new-unity-project-my-starter-kit/). | [docs](https://docs.github.com/en/actions) |
| pre-commit | Strict quality gates so agents never commit bad code. See [(Strict) Precommit Hooks](https://andrewallbright.com/strict-precommit-hooks-shifting-ai-feedback-left/). | [docs](https://pre-commit.com/) |
| Task | The Taskfile runner I put in every project. | [docs](https://taskfile.dev/) |
| Game CI | Unity builds in CI. | [docs](https://game.ci/docs) |
| Spinnaker | Progressive Kubernetes deployments with automatic rollback. | [docs](https://spinnaker.io/docs/) |
| JFrog Artifactory | Routed cluster image pulls through an approved registry. | [docs](https://jfrog.com/help/r/jfrog-artifactory-documentation) |
| TeamCity | CI builds. | [docs](https://www.jetbrains.com/help/teamcity/teamcity-documentation.html) |

### Observability and security

| Technology | Brief | Docs |
|------------|-------|------|
| Prometheus | Metrics and PromQL. | [docs](https://prometheus.io/docs/) |
| Grafana | Dashboards, including "pane of glass" designs. | [docs](https://grafana.com/docs/) |
| Fluent Bit | Log shipping. | [docs](https://docs.fluentbit.io/manual) |
| Splunk | Dashboards tracking feature flags and security-fix rollouts. | [docs](https://docs.splunk.com/Documentation) |
| OpenTelemetry | Traces, metrics and logs in my own projects. | [docs](https://opentelemetry.io/docs/) |
| gitleaks | Secret scanning on every commit. | [docs](https://github.com/gitleaks/gitleaks#readme) |
| OSV-Scanner | Dependency vulnerability scanning. | [docs](https://google.github.io/osv-scanner/) |
| Kubernetes RBAC | Least-privilege access in clusters. | [docs](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) |

### Data

| Technology | Brief | Docs |
|------------|-------|------|
| MariaDB | Confidently pragmatic. This is my SQL database of choice. #wordpress #golang #python #nodejs | [docs](https://mariadb.org/documentation/) |
| SQLite | Embedded storage in my CLIs and static-site pipelines, such as Treemand and Anthem World. | [docs](https://www.sqlite.org/docs.html) |
| SQL Server | Query and performance tuning on a large production system. | [docs](https://learn.microsoft.com/en-us/sql/sql-server/) |
| Redis | Caching and client library resiliency. #redis | [docs](https://redis.io/docs/latest/) |
| Apache Kafka | Event streaming. #kafka | [docs](https://kafka.apache.org/documentation/) |
| Apache ZooKeeper | Distributed coordination. #zookeeper | [docs](https://zookeeper.apache.org/doc/current/) |

### Networking and web servers

| Technology | Brief | Docs |
|------------|-------|------|
| NGINX | Experienced. My reverse proxy technology of choice. | [docs](https://nginx.org/en/docs/) |
| Apache HTTP Server | Comfortable. Thank you `.htaccess` files. | [docs](https://httpd.apache.org/docs/) |
| HAProxy | Load balancing and proxying. #haproxy | [docs](https://www.haproxy.org/#docs) |
| F5 BIG-IP | Load balancing in production. | [docs](https://techdocs.f5.com/) |
| gRPC | Service-to-service APIs. #grpc | [docs](https://grpc.io/docs/) |

### Applied AI

| Technology | Brief | Docs |
|------------|-------|------|
| Claude Code | My daily agentic coding tool. See [From AI Harness to Software Factory](https://andrewallbright.com/from-ai-harness-to-software-factory-a-practical-agentic-engineering-stack/). | [docs](https://code.claude.com/docs/en/overview) |
| GitHub Copilot | AI pair programming in the editor. | [docs](https://docs.github.com/en/copilot) |
| Model Context Protocol (MCP) | Giving agents tools and context, including [Specbase](https://andrewallbright.com/portfolio/specbase/). | [docs](https://modelcontextprotocol.io/docs/getting-started/intro) |
| Ollama | Running open models locally. See [Local-first, Offline-first Programming with AI](https://andrewallbright.com/local-first-offline-first-programming-with-ai-when/). | [docs](https://docs.ollama.com/) |
| LiteLLM | One OpenAI-style interface across many model providers. | [docs](https://docs.litellm.ai/) |
| Stable Diffusion | Image generation. #generative-ai #stable-diffusion | [Diffusers docs](https://huggingface.co/docs/diffusers/en/api/pipelines/stable_diffusion/overview) |
| Hugging Face | Model hub behind [AssetGen](https://andrewallbright.com/portfolio/assgen/). See [Explaining Hugging Face](https://andrewallbright.com/explaining-hugging-face-%f0%9f%a4%97/). | [docs](https://huggingface.co/docs) |
| PyTorch | Local GPU inference. | [docs](https://pytorch.org/docs/stable/index.html) |
| Unity ML-Agents | Reinforcement learning for game agents. #reinforcement-learning | [docs](https://unity-technologies.github.io/ml-agents/) |
| MediaPipe | Hand and pose landmark models. See [Useful Enums for MediaPipe](https://andrewallbright.com/possibly-useful-enums-for-mediapipe-hand-and-pose-landmarker-model/). #computer-vision | [docs](https://ai.google.dev/edge/mediapipe/solutions/guide) |

### Games and robotics

| Technology | Brief | Docs |
|------------|-------|------|
| Unity | Working on it. Developing an appropriate mental model for creating games has been a fun hobby. #webGL #3Dgames #simulations | [manual](https://docs.unity3d.com/Manual/index.html), [scripting API](https://docs.unity3d.com/ScriptReference/) |
| Godot | Open source game engine, scripted in GDScript. | [docs](https://docs.godotengine.org/en/stable/) |
| Pygame | Quick 2D prototypes in Python. | [docs](https://www.pygame.org/docs/) |
| Phaser | 2D browser games in JavaScript. | [docs](https://docs.phaser.io/phaser/getting-started/what-is-phaser) |
| Arduino | Experienced. | [docs](https://docs.arduino.cc/) |
| ESP32 | See [ESP32 as a Robot Brain](https://andrewallbright.com/esp32-as-a-robot-brain/). | [ESP-IDF docs](https://docs.espressif.com/projects/esp-idf/en/stable/) |
| Raspberry Pi | Home lab and robotics projects. #raspberry-pi | [docs](https://www.raspberrypi.com/documentation/) |

### Editors and IDEs

A crafts person is only as good as the tools they use. 🛠

| Editor | Purpose | Docs |
|--------|---------|------|
| vim | General use | [docs](https://www.vim.org/docs.php) |
| IntelliJ IDEA | Scala, Docker, Kubernetes, Terraform | [docs](https://www.jetbrains.com/help/idea/) |
| Rider | .NET apps, Unity game programming | [docs](https://www.jetbrains.com/help/rider/) |
| DataGrip | Interact with data stores | [docs](https://www.jetbrains.com/help/datagrip/) |
| GoLand | Go! | [docs](https://www.jetbrains.com/help/go/) |
| PyCharm | Python | [docs](https://www.jetbrains.com/help/pycharm/) |
| PhpStorm | WordPress theme and plugin development, Laravel projects | [docs](https://www.jetbrains.com/help/phpstorm/) |
| WebStorm | Static site assets | [docs](https://www.jetbrains.com/help/webstorm/) |
| CLion | Arduino C, ESP C | [docs](https://www.jetbrains.com/help/clion/) |
| VS Code | Lightweight GUI editor | [docs](https://code.visualstudio.com/docs) |
