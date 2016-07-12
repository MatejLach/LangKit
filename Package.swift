import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "Build", "Frameworks", "Examples", "LangKit-iOS"],
    dependencies:
    [
        .Package(url: "https://github.com/jatoben/CommandLine", majorVersion: 2),
    ],
    targets:
    [
        Target(
            name: "LangKit"
        ),
        Target(
            name: "LangKitDemo",
            dependencies: [ "LangKit" ]
        )
    ]
)
