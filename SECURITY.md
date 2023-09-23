# GCAPI Security

## Table of Contents

- [GCAPI Security](#gcapi-security)
  - [Table of Contents](#table-of-contents)
  - [Supported Versions](#supported-versions)
  - [Reporting a Vulnerability](#reporting-a-vulnerability)
  - [Getting Starting](#getting-starting)
  - [Testing Tools](#testing-tools)
    - [GitLeaks](#gitleaks)
      - [References](#references)

## Supported Versions

| Version   | Supported          |
| --------- | ------------------ |
| < 1.0.0   | :x:                |

## Reporting a Vulnerability

This project is not open for vulnerability reports. We DO NOT recommend using this in production—it is only a test development project. We will not fix vulnerabilities until this project get's pushed into production.

## Getting Starting

Generate App Secrets

    Use `openssl rand -hex 32` to generate a secret key.

## Testing Tools

### GitLeaks

    gitleaks detect --verbose --config=./gitleaks.toml

#### References

- [GitLeaks Repository](https://github.com/zricethezav/gitleaks)
- [GitLeaks Allow List for Inline Cases of False Positive Secrets Leak](https://github.com/zricethezav/gitleaks/issues/579)
- [GitLeaks Custom Config .toml File](https://github.com/zricethezav/gitleaks/issues/787)
- [How to Maintain a Secure Repository](https://docs.microsoft.com/en-us/learn/modules/maintain-secure-repository-github/2-how-to-maintain-secure-repository)
- [Removing Secrets from Your Git History](https://gist.github.com/gjerokrsteski/e4a10352448158ba827493eb116cda51)
