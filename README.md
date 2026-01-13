# firm-CI

**Tag-driven firmware CI pipeline for Raspberry Pi Pico (Demo Project)**

---

## Overview

`firm-CI` is a **demonstration-only IoT DevOps project** that showcases how to build, version, and publish firmware **automatically and deterministically** using **GitHub Actions**, **Docker**, and a **self-hosted runner**.

The pipeline generates Raspberry Pi Pico firmware **only when a Git tag is pushed**, ensuring clean release semantics and traceability between source, build environment, and output artifact.

This repository is intentionally minimal in firmware logic (a Pico SDK blink example) and maximal in **CI/CD clarity**.

---

## What This Project Demonstrates 

- Tag-triggered firmware releases (no tag → no firmware)
- Deterministic builds via Dockerized toolchains
- Self-hosted CI runner usage for cost and control
- Firmware artifact versioning tied to Git tags
- Pushing generated `.uf2` firmware back into the repository
- Separation of source code, SDK, and build output
- Reproducibility over convenience

This is **not** production-ready firmware infrastructure. It is a **proof-of-competence** CI pipeline.

---

## Hardware & Firmware Scope

- **Target boards**
    - Raspberry Pi Pico
- **Firmware source**
    - Located in `src/`
    - Uses `blink_simple.c` from Pico SDK examples (demo purpose)
- **Language**
    - Mixed C / C++

The firmware logic is intentionally trivial. 

---

## Release Model 
- **Source-of-truth branch:** `main`
- **Trigger condition:** push of a Git tag matching `v*`
- **No tag = no build**
- **Tags must be created on `main`**

This avoids:

- Accidental firmware builds
- CI noise
- Ambiguous release state
    

---

## CI Pipeline Architecture

```
Developer    
    |    
    |-- git tag vX.Y.Z    
    |-- git push --tags    
    v 
GitHub Actions    
    |    
    |-- Self-hosted Runner (Arch Linux)    
    |    
    |-- Checkout firmware repo (main)    
    |-- Checkout pico-sdk (external)    
    |    
    |-- Docker image build (only if Dockerfile changed)    
    |    
    |-- Dockerized firmware build    
    |    
    |-- Version .uf2 using Git tag    
    |    
    |-- Commit firmware back to main    
    v 
build/*.uf2 (versioned)
```

---

## Why Self-Hosted Runner?

- Chaching of repository and docker-images(toolchains). This is network heavy.
- Reduce time to download toolchain, clone pico-sdk repo.
- Lower cost than hosted runners for longer/complex firmware builds
- Full Docker control
- Predictable environment
- No hosted-runner time limits
- Suitable for embedded workflows
    

**Runner OS:** Arch Linux  
**Motivation:** Cost, speed optimization and control

---

## Docker Usage Philosophy

Docker is used for **both**:

1. **Toolchain pinning**
    - Pico SDK
    - CMake
    - Ninja
        
2. **Reproducible builds**
    - Same inputs → same outputs
    - Host OS becomes irrelevant

Docker images are rebuilt **only when the Dockerfile changes**, avoiding unnecessary churn.

---

## Firmware Artifact Strategy

- Output format: `.uf2`
- Location: `build/`
- Versioning scheme:
    `firmware-name-vX.Y.Z.uf2`
- Version source: Git tag (`github.ref_name`)

Artifacts are **committed back to `main` intentionally** for demonstration purposes.

> Yes, committing binaries is usually discouraged.  
> Here, it is deliberate to show traceability and CI authority.

---

## Version Traceability 

|Tag|Firmware File|Source Commit|Build Environment|
|---|---|---|---|
|`v1.0.0`|`blink-v1.0.0.uf2`|Tag commit|Docker image|
|`v1.1.0`|`blink-v1.1.0.uf2`|Tag commit|Same image|

Every firmware artifact is:

- Traceable to a Git tag
- Traceable to source code
- Built in a known container

---

## CI Statistics 

> These are representative outputs of the pipeline behavior.

### Artifact Version History

- One firmware per Git tag
- Zero firmware without a tag
- No overwrites
    
### Tag → Firmware Traceability

- 1:1 mapping between tag and `.uf2`
- Artifact name embeds version explicitly

### Docker Image Reuse Rate

- Docker image rebuilt **only when Dockerfile changes**
- Firmware builds reuse cached image
- Typical reuse rate: **>90%** across tags

---

## How to Release Firmware

```
# ensure main is clean git checkout main git pull  
# create version tag git tag v1.0.0  
# push tag git push origin v1.0.0
```

That’s it.

No manual build steps.  
No UI clicks.  
No ambiguity.

---

## Known Limitations (Intentional)

- Binary artifacts committed to repository
- No GitHub Releases integration
- No semantic version enforcement
- No hardware-in-the-loop testing
- No rollback automation

These are out of scope for a demo pipeline.

---

## Reuse Guidance

This repository **can be reused** as a template if you:

- Replace firmware logic in `src/`
- Adjust artifact handling (e.g. GitHub Releases)
- Harden branch protections
- Add test stages
