function gacp {

    param (

        [string]$Message = "auto"

    )


    try {

        $currentDateTime = Get-Date -Format "dd-MM-yyyy-HH-mm"

        $commitMessage = "$($currentDateTime)-$($Message)"


        Write-Host "[RUN] 'git add .'"

        git add .

        if ($LASTEXITCODE -ne 0) {

            Write-Error "git add . failed."

            return

        }


        Write-Host "[RUN] 'git commit -m ""$commitMessage""'"

        git commit -m "$commitMessage"

        if ($LASTEXITCODE -ne 0) {

            $gitStatus = git status --porcelain

            if ($gitStatus -eq "") {

                Write-Host "Nothing to commit, working tree clean. Skipping push."

                return

            } else {

                Write-Error "git commit failed."

                return

            }

        }


        Write-Host "[RUN] 'git push'"

        git push

        if ($LASTEXITCODE -ne 0) {

            Write-Error "git push failed."

            return

        }


        Write-Host "[OK]" -ForegroundColor Green

        Write-Host "message: ""$commitMessage""" -ForegroundColor Green


    } catch {

        Write-Error "[ERROR]: $($_.Exception.Message)"

    }

} 