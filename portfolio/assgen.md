---
title: "AssGen"
slug: assgen
excerpt: "A Kubernetes-style client/server CLI that turns prompts into 3D models, textures, sound effects and music with open-source Hugging Face models."
wp_post_id: 3900
url: https://aallbrig.github.io/AssetGen/
repo: aallbrig/AssetGen
image: images/assgen.png
---
AssGen models the typical 3D game-development workload as a CLI graph, then routes each task, such as concept art from a prompt, a sound effect or a rigged model, to an open-source Hugging Face model running on your own GPU.
No cloud bill and no proprietary API.

The client and server are separate processes. The client talks REST to `assgen-server`, which queues jobs in SQLite and works through them on a worker thread. Point the client at a beefy GPU box from your laptop, or let it start a local server automatically.

![AssGen documentation site](assgen.png)

### Tech stack

- **Language:** Python 3.11+ (nearly all of the repo)
- **CLI:** Typer and Rich
- **Server:** FastAPI on Uvicorn, Pydantic settings, an SQLite job queue, HTTPX client
- **Models:** `huggingface-hub` for download and caching, with optional PyTorch, Transformers, Diffusers, Accelerate and Trimesh for local GPU inference
- **Observability:** optional OpenTelemetry (FastAPI, HTTPX and logging instrumentation)
- **Quality and release:** pytest with coverage, Ruff, Bandit, pip-audit, pre-commit, MkDocs docs site, PyInstaller and Chocolatey packaging
- **License:** MIT

Source: [aallbrig/assgen](https://github.com/aallbrig/assgen)
