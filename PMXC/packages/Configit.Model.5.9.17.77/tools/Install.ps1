# This was adapted from http://stackoverflow.com/questions/6681281/visual-studio-2010-dte-how-to-make-added-dll-reference-absolute-and-not-copied

param($installPath, $toolsPath, $package, $project)

[Reflection.Assembly]::Load("Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A")
$msbuildproj = [Microsoft.Build.Evaluation.PROJECTCOLLECTION]::GlobalProjectCollection.GETLOADEDPROJECTS($project.FullName).Item(0)
$refs = $msbuildproj.GetItems("Reference")

foreach ($packref in $package.AssemblyReferences | select Name -uniq) {
    $refname = $packref.Name.TrimEnd(".dll")
    $dteref = $project.Object.References.Item($refname)
    $neededref = $null
    
    foreach ($ref in $refs) {
        if ($ref.EvaluatedInclude -eq $refname -or $ref.EvaluatedInclude.StartsWith($refname + ",")) {
            $neededref = $ref
        }
    }

    if ($neededref -ne $null) {
        $newFileUri = [system.URI] $dteref.Path
        $projectUri = [system.URI] (([IO.Path]::GetDirectoryName($project.FullName).TrimEnd([IO.Path]::DirectorySeparatorChar)) + ([IO.Path]::DirectorySeparatorChar))
        $relativeUri = $projectUri.MakeRelativeUri($newFileUri)
        $hintpath = $relativeUri.ToString()
        if($relativeUri.ToString().Contains("Release/")) {
            $hintpath = $relativeUri.ToString().Replace("Release/", "`$(Configuration)/")
        }
        if($relativeUri.ToString().Contains("Debug/")) {
            $hintpath = $relativeUri.ToString().Replace("Debug/", "`$(Configuration)/")
        }
        # for some reason the Uri object likes forward-slashes instead of backslashes...
        $hintpath = $hintpath.Replace("/", "\")
        $neededref.SetMetadataValue("HintPath", $hintpath)
    }
}