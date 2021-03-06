param($installPath, $toolsPath, $package, $project)

$itemlabel = $package.Id + "-IncludeLabel"
$msbuildproj = @([Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GETLOADEDPROJECTS($project.FullName))[0]
$projecturi = [system.URI] (([IO.Path]::GetDirectoryName($project.FullName).TrimEnd([IO.Path]::DirectorySeparatorChar)) + ([IO.Path]::DirectorySeparatorChar))
$installuri = [system.URI] (([IO.Path]::GetDirectoryName((Split-Path $toolspath -parent) + ([IO.Path]::DirectorySeparatorChar)).TrimEnd([IO.Path]::DirectorySeparatorChar)) + ([IO.Path]::DirectorySeparatorChar))
$relinstalluri = $projecturi.MakeRelativeUri($installuri)
$newitem = $msbuildproj.Xml.AddItem("Content", (Join-Path $relinstalluri.ToString() "NativeBinaries\**\*"))
$newitem.Label = $itemlabel
$newitem.AddMetadata("CopyToOutputDirectory", "PreserveNewest") | Out-Null
$newitem.AddMetadata("Link", "%(RecursiveDir)%(FileName)%(Extension)") | Out-Null
$newitem.AddMetadata("Visible", "False") | Out-Null
$project.Save()
$msbuildproj.ReevaluateIfNecessary()