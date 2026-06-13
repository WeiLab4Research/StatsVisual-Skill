# Windows Dependency Setup

Use this when R package installation fails with Windows elevation errors, blocked system libraries, or restricted Codex networking.

## One-Time Bootstrap

Open PowerShell manually, `cd` to the repository root, then run this in a normal user PowerShell, not an elevated administrator shell:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1
```

Do not rely on right-click "Run with PowerShell" because the temporary window can close before you can read errors.

This installs common plotting packages into the repository-local library by default:

```text
.r-medical-graphics-library/
```

This is preferred for Codex desktop because future conversations can usually read it from the workspace. The directory is ignored by Git and should not be uploaded.

The bootstrap writes a log file in the repository root:

```text
r-medical-graphics-bootstrap.log
```

It also updates available `.Renviron` files with `R_MEDICAL_GRAPHICS_LIB` so future R sessions can find the library.

Verify installation with:

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R
```

Optional Bioconductor heatmap packages can be checked with:

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R --include-optional
```

## Use A Different CRAN Mirror

If `cloud.r-project.org` is slow or blocked, choose a reachable mirror. The bootstrap tries several mirrors automatically, but you can still provide one:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://cran.rstudio.com"
```

For users in mainland China, try a local mirror if available in their environment, for example:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
```

Or pass an explicit ordered mirror list:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepos "https://mirrors.ustc.edu.cn/CRAN/","https://mirrors.tuna.tsinghua.edu.cn/CRAN/","https://cloud.r-project.org"
```

If nested PowerShell treats the mirror list as one comma-separated string, this is also accepted:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepos "https://mirrors.ustc.edu.cn/CRAN/,https://mirrors.tuna.tsinghua.edu.cn/CRAN/,https://cloud.r-project.org"
```

## Alternate Library Locations

If you want each run to carry its own packages, use a run-specific project library:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -Library "runs/mr_chd_trial/R-library"
```

The default repository-local library is equivalent to:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -Library ".r-medical-graphics-library"
```

If a shell cannot read `.Renviron`, set the library explicitly before running R:

```powershell
$env:R_MEDICAL_GRAPHICS_LIB = "C:\absolute\path\to\.r-medical-graphics-library"
```

## Interpreting Errors

- `Os code 740` or `请求的操作需要提升。`: Windows tried to use a location or process needing elevation. Use the repository-local `.r-medical-graphics-library/` or a project library; do not treat this as a CRAN mirror error.
- `cannot open URL .../PACKAGES`: R cannot reach that CRAN repository. Let the bootstrap try multiple mirrors, provide a mirror reachable from the user's network, or use an approved network/proxy context.
- VPNs can change which mirrors are reachable. With a VPN on, overseas mirrors such as `https://cloud.r-project.org` or `https://cran.rstudio.com` may work better; with a VPN off in mainland China, local mirrors may work better. A `403 Forbidden` from a mirror usually means that mirror rejected the current network route, not that the package is unavailable.
- package compile errors: install Rtools for packages that need compilation, or use binary packages from a compatible CRAN mirror.
