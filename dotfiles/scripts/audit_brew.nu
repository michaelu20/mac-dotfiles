#!/usr/bin/env nu

# Audit Homebrew packages and display them in a clean table
def main [] {
    print "Fetching Homebrew data..."
    
    let raw_data = (brew info --json=v2 --installed | from json)
    
    let formulae = ($raw_data.formulae | each { |it| 
        {
            name: $it.name,
            version: $it.installed.version.0,
            type: "formula",
            outdated: $it.outdated,
            description: $it.desc
        }
    })

    let casks = ($raw_data.casks | each { |it| 
        {
            name: $it.token,
            version: $it.version,
            type: "cask",
            outdated: $it.outdated,
            description: $it.desc
        }
    })

    let all_pkgs = ($formulae | append $casks | sort-by name)
    
    $all_pkgs | table
}
