param(
  [string]$Library = "",
  [string]$CranRepo = "https://cloud.r-project.org",
  [string[]]$CranRepos = @(),
  [string[]]$Packages = @(
    "ggplot2", "ragg", "dplyr", "tidyr", "readr", "readxl", "tibble", "purrr",
    "scales", "forcats", "stringr", "lubridate",
    "patchwork", "cowplot", "ggpubr", "ggrepel",
    "RColorBrewer", "viridis", "viridisLite", "ggsci",
    "ggridges", "ggbeeswarm", "ggdist", "ggpointdensity", "GGally", "ggExtra",
    "pheatmap", "corrplot", "forestplot", "broom",
    "survival", "survminer", "ggsurvfit",
    "ggtern", "svglite", "magick", "showtext", "sysfonts"
  ),
  [string[]]$BiocPackages = @("ComplexHeatmap", "circlize"),
  [string[]]$BiocRepos = @("https://bioconductor.org/packages/3.22/bioc", "https://mirrors.tuna.tsinghua.edu.cn/bioconductor/packages/3.22/bioc", "https://mirrors.ustc.edu.cn/bioc/packages/3.22/bioc"),
  [switch]$RequireBioc,
  [switch]$PauseOnExit
)

$ErrorActionPreference = "Stop"
$LogFile = Join-Path (Get-Location) "r-medical-graphics-bootstrap.log"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillRoot = Split-Path -Parent $ScriptRoot
$RepoRoot = Split-Path -Parent (Split-Path -Parent $SkillRoot)

function Write-Step {
  param([string]$Message)
  $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
  Write-Host $line
  Add-Content -LiteralPath $LogFile -Value $line -Encoding UTF8
}

try {
  "R medical graphics bootstrap log" | Set-Content -LiteralPath $LogFile -Encoding UTF8
  Write-Step "Working directory: $(Get-Location)"

  if (-not $Library -or $Library.Trim().Length -eq 0) {
    $Library = Join-Path $RepoRoot ".r-medical-graphics-library"
  }

  if (-not (Get-Command Rscript -ErrorAction SilentlyContinue)) {
    throw "Rscript is not on PATH. Install R or add Rscript.exe to PATH before running this bootstrap script."
  }

  New-Item -ItemType Directory -Force -Path $Library | Out-Null
  $Library = (Resolve-Path -LiteralPath $Library).Path
  $testFile = Join-Path $Library ".write-test"
  "ok" | Set-Content -LiteralPath $testFile -Encoding ASCII
  Remove-Item -LiteralPath $testFile -Force

  $repoList = @()
  if ($CranRepos.Count -gt 0) {
    $repoList += $CranRepos
  } else {
    $repoList += $CranRepo
    $repoList += "https://cloud.r-project.org"
    $repoList += "https://cran.rstudio.com"
    $repoList += "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
    $repoList += "https://mirrors.ustc.edu.cn/CRAN/"
  }
  $repoList = $repoList |
    ForEach-Object { $_ -split "," } |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and $_.Length -gt 0 } |
    Select-Object -Unique

  $packageArgs = $Packages | ForEach-Object { '"' + ($_ -replace '"', '\"') + '"' }
  $repoArgs = $repoList | ForEach-Object { '"' + ($_ -replace '"', '\"') + '"' }
  $rCode = @"
lib <- normalizePath("$($Library -replace '\\', '/')", winslash = "/", mustWork = TRUE)
.libPaths(unique(c(lib, .libPaths())))
repos_list <- c($($repoArgs -join ', '))
pkgs <- unique(c($($packageArgs -join ', ')))
options(timeout = max(300, getOption("timeout")))
if (.Platform[['OS.type']] == 'windows') {
  options(download.file.method = 'libcurl')
}
missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
last_error <- NULL
if (length(missing) > 0) {
  for (repo in repos_list) {
    cat("Trying CRAN repo:", repo, "\n")
    ok <- tryCatch({
      install.packages(missing, lib = lib, repos = repo, dependencies = c("Depends", "Imports", "LinkingTo"))
      TRUE
    }, error = function(e) {
      last_error <<- conditionMessage(e)
      cat("Repository error:", last_error, "\n")
      FALSE
    })
    still_missing_now <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
    if (length(still_missing_now) == 0) {
      break
    }
    missing <- still_missing_now
  }
}
still_missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(still_missing) > 0) {
  stop("Failed to install packages: ", paste(still_missing, collapse = ", "),
       if (!is.null(last_error)) paste0(". Last error: ", last_error) else "",
       call. = FALSE)
}
cat("R medical graphics package library ready:\n", lib, "\n", sep = "")
"@

  $tempScript = Join-Path $env:TEMP "r-medical-graphics-bootstrap.R"
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($tempScript, $rCode, $utf8NoBom)

  Write-Step "Installing packages into user-writable library: $Library"
  Write-Step "Using CRAN repos: $($repoList -join '; ')"
  Write-Step "Packages: $($Packages -join ', ')"

  $oldErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  try {
    $rOutput = & Rscript $tempScript 2>&1
    $rExitCode = $LASTEXITCODE
  }
  finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }
  $rOutput | ForEach-Object { $_.ToString() } | Tee-Object -FilePath $LogFile -Append
  if ($rExitCode -ne 0) {
    throw "Rscript package installation failed with exit code $rExitCode. See log: $LogFile"
  }

  if ($BiocPackages.Count -gt 0) {
    $biocArgs = $BiocPackages | ForEach-Object { '"' + ($_ -replace '"', '\"') + '"' }
    $biocRepoList = $BiocRepos |
      ForEach-Object { $_ -split "," } |
      ForEach-Object { $_.Trim().TrimEnd("/") } |
      Where-Object { $_ -and $_.Length -gt 0 } |
      Select-Object -Unique
    $biocRepoArgs = $biocRepoList | ForEach-Object { '"' + ($_ -replace '"', '\"') + '"' }
    $biocCode = @"
lib <- normalizePath("$($Library -replace '\\', '/')", winslash = "/", mustWork = TRUE)
.libPaths(unique(c(lib, .libPaths())))
repos <- "$($repoList[0])"
bioc_repos <- c($($biocRepoArgs -join ', '))
options(timeout = max(300, getOption("timeout")))
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", lib = lib, repos = repos, dependencies = c("Depends", "Imports", "LinkingTo"))
}
bioc_pkgs <- unique(c($($biocArgs -join ', ')))
missing <- bioc_pkgs[!vapply(bioc_pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  last_error <- NULL
  for (repo in bioc_repos) {
    cat("Trying Bioconductor repo:", repo, "\n")
    repos_override <- BiocManager::repositories()
    repos_override["BioCsoft"] <- repo
    ok <- tryCatch({
      BiocManager::install(missing, lib = lib, ask = FALSE, update = FALSE, site_repository = character(), repos = repos_override)
      TRUE
    }, error = function(e) {
      last_error <<- conditionMessage(e)
      cat("Bioconductor repo error:", last_error, "\n")
      FALSE
    })
    still_missing_now <- bioc_pkgs[!vapply(bioc_pkgs, requireNamespace, logical(1), quietly = TRUE)]
    if (length(still_missing_now) == 0) break
    missing <- still_missing_now
  }
}
still_missing <- bioc_pkgs[!vapply(bioc_pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(still_missing) > 0) {
  stop("Failed to install Bioconductor packages: ", paste(still_missing, collapse = ", "), call. = FALSE)
}
cat("Bioconductor packages ready:", paste(bioc_pkgs, collapse = ", "), "\n")
"@
    $biocScript = Join-Path $env:TEMP "r-medical-graphics-bootstrap-bioc.R"
    [System.IO.File]::WriteAllText($biocScript, $biocCode, $utf8NoBom)
    Write-Step "Bioconductor packages: $($BiocPackages -join ', ')"
    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
      $biocOutput = & Rscript $biocScript 2>&1
      $biocExitCode = $LASTEXITCODE
    }
    finally {
      $ErrorActionPreference = $oldErrorActionPreference
    }
    $biocOutput | ForEach-Object { $_.ToString() } | Tee-Object -FilePath $LogFile -Append
    if ($biocExitCode -ne 0) {
      $message = "Bioconductor package installation failed with exit code $biocExitCode. Core CRAN packages may still be installed. See log: $LogFile"
      if ($RequireBioc) {
        throw $message
      } else {
        Write-Step "WARNING: $message"
      }
    }
  }

  $rHomeScript = Join-Path $env:TEMP "r-medical-graphics-home.R"
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($rHomeScript, "cat(normalizePath(path.expand('~'), winslash='/', mustWork=FALSE))", $utf8NoBom)
  $rHome = (& Rscript $rHomeScript 2>$null).Trim()
  $renvironTargets = @()
  if ($env:USERPROFILE) { $renvironTargets += (Join-Path $env:USERPROFILE ".Renviron") }
  if ($rHome) { $renvironTargets += (Join-Path $rHome ".Renviron") }
  $renvironTargets = $renvironTargets | Select-Object -Unique
  $renvironLine = "R_MEDICAL_GRAPHICS_LIB=$($Library -replace '\\', '/')"
  foreach ($renviron in $renvironTargets) {
    $renvironDir = Split-Path -Parent $renviron
    if ($renvironDir) { New-Item -ItemType Directory -Force -Path $renvironDir | Out-Null }
    if (Test-Path -LiteralPath $renviron) {
      $existing = Get-Content -LiteralPath $renviron
      $filtered = $existing | Where-Object { $_ -notmatch "^R_MEDICAL_GRAPHICS_LIB=" }
      $filtered + $renvironLine | Set-Content -LiteralPath $renviron -Encoding ASCII
    } else {
      $renvironLine | Set-Content -LiteralPath $renviron -Encoding ASCII
    }
    Write-Step "Updated R environment file: $renviron"
  }

  Write-Step "Set R_MEDICAL_GRAPHICS_LIB=$Library"
  Write-Step "Bootstrap completed successfully."
  Write-Host ""
  Write-Host "Success. Log file:"
  Write-Host "  $LogFile"
  Write-Host "Verify with:"
  Write-Host "  Rscript skills/StatsVisual-Skill/scripts/check_dependencies.R"
}
catch {
  Write-Step "ERROR: $($_.Exception.Message)"
  Write-Host ""
  Write-Host "Bootstrap failed. Log file:"
  Write-Host "  $LogFile"
  throw
}
finally {
  if ($PauseOnExit) {
    Write-Host ""
    Read-Host "Press Enter to close"
  }
}