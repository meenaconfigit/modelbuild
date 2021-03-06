param($installPath, $toolsPath, $package, $project)

$itemlabel = $package.Id + "-IncludeLabel"
$msbuildproj = @([Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GETLOADEDPROJECTS($project.FullName))[0]

$itemtodelete = $null
$msbuildproj.Xml.Items | ForEach-Object {
    if($_.Label -eq $itemlabel) {
        $itemtodelete = $_
    }
}

if($itemtodelete -ne $null) {
    $parent = $itemtodelete.Parent
    $parent.RemoveChild($itemtodelete)
    $project.Save()
    $msbuildproj.ReevaluateIfNecessary()
}