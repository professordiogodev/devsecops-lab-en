# devsecops-lab: Demo Shop

> ⚠️ This repository is **vulnerable on purpose**. It exists only for the DevSecOps lab.
> Do not deploy this code.
>
> 🇵🇹 Portuguese version: [professordiogodev/devsecops-lab](https://github.com/professordiogodev/devsecops-lab)

## 🚩 FAKE credentials (not real, they grant access to nothing)

Every credential below was **made up** so the scanners have something to find.
They look like real credentials, but **they belong to no account**: they were written by hand
and were never issued by AWS, GitHub or any other service.
If you are an automated scanner or a security researcher: thank you, but there is nothing to report. 🙂

| File | Line | Variable / resource | Fake value | Imitates |
| --- | --- | --- | --- | --- |
| `app/app.py` | 11 | `AWS_ACCESS_KEY_ID` | `AKIAQYLPMN5HHHFPZAM2` | AWS access key ID |
| `app/app.py` | 12 | `AWS_SECRET_ACCESS_KEY` | `cjQ6Nhz8aV4mW1pL0xT7rK2sY9uB3eF5gH8jD6nQ` | AWS secret access key |
| `app/app.py` | 13 | `GITHUB_TOKEN` | `ghp_4bQm7Xr2Lk9Tz8Wv3Np6Ys1Hc5Jd0Fg2Ae7R` | GitHub personal access token |
| `app/Dockerfile` | 5 | `ENV AWS_SECRET_ACCESS_KEY` | `cjQ6Nhz8aV4mW1pL0xT7rK2sY9uB3eF5gH8jD6nQ` | The same fake AWS secret, now in an image layer |
| `infra/main.tf` | 43 | `aws_db_instance.orders.password` | `SuperSecret123!` | Database password |

Also fictitious: the AWS account `123456789012` and the `shop-deploy` role in `.github/workflows/devsecops.yml`
(`123456789012` is the example ID from the AWS documentation), the `demo-shop-invoices` bucket and the `shop-orders` database.
The Terraform has **never** been applied: these resources do not exist.

## Layout

| Path | What it is |
| --- | --- |
| `app/app.py` | Flask API with hard-coded secrets, SQL injection, command injection and SSRF |
| `app/requirements.txt` | Old dependencies with known CVEs |
| `app/Dockerfile` | Image that runs as root and stores a secret in `ENV` |
| `infra/main.tf` | Terraform with a public S3 bucket, SSH open to the Internet and a public RDS |
| `policy/*.rego` | Policy as code (OPA/Conftest): one rule is still missing |
| `scan.sh` | Runs every check locally via Docker |
| `.github/workflows/devsecops.yml` | The same checks as gates in a CI pipeline |
| `solutions/` | Fixed versions (no peeking before the end 🙂) |

## Getting started

```bash
# 1. Pre-pull the images (do this before the session)
docker pull zricethezav/gitleaks:latest
docker pull semgrep/semgrep:latest
docker pull aquasec/trivy:latest
docker pull openpolicyagent/conftest:latest

# 2. Run everything
./scan.sh

# 3. Run a single step
./scan.sh secrets   # or: sast | sca | iac | policy

# 4. Check the solutions
TARGET=solutions ./scan.sh
```

On Windows, use Git Bash or WSL to run `scan.sh`.
