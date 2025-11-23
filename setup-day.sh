#!/bin/bash

# Usage: ./setup-day.sh <year> <day>
# Example: ./setup-day.sh 2025 2

if [ $# -ne 2 ]; then
    echo "Usage: ./setup-day.sh <year> <day>"
    echo "Example: ./setup-day.sh 2025 2"
    exit 1
fi

YEAR=$1
DAY=$(printf "%02d" $2)
PROJECT_NAME="${YEAR}"
DAY_DIR="${YEAR}/Day${DAY}"

# Create directory structure
mkdir -p "${DAY_DIR}"

# Create .csproj file
cat > "${DAY_DIR}/${PROJECT_NAME}.csproj" << EOF
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net9.0</TargetFramework>
    <RootNamespace>_${PROJECT_NAME}</RootNamespace>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>

</Project>
EOF

# Create Program.cs template
cat > "${DAY_DIR}/Program.cs" << 'EOF'
// Read all lines from the input file
var input = File.ReadAllLines("input.txt");

// Part 1
Console.WriteLine("Part 1:");
var part1Result = SolvePart1(input);
Console.WriteLine($"Result: {part1Result}");

// Part 2
Console.WriteLine("\nPart 2:");
var part2Result = SolvePart2(input);
Console.WriteLine($"Result: {part2Result}");

static int SolvePart1(string[] input)
{
    // TODO: Implement Part 1 solution
    return 0;
}

static int SolvePart2(string[] input)
{
    // TODO: Implement Part 2 solution
    return 0;
}
EOF

# Create empty input.txt
touch "${DAY_DIR}/input.txt"

# Create sample.txt for test cases
cat > "${DAY_DIR}/sample.txt" << 'EOF'
# Add sample input here for testing
EOF

# Add project to solution if it doesn't exist
SOLUTION_FILE="AdventOfCode.sln"
PROJECT_GUID=$(uuidgen | tr '[:lower:]' '[:upper:]')

# Check if solution folder exists
if ! grep -q "\"${YEAR}\"" "${SOLUTION_FILE}"; then
    FOLDER_GUID=$(uuidgen | tr '[:lower:]' '[:upper:]')
    # Add solution folder (before Global section)
    sed -i "/^Global$/i Project(\"{2150E333-8FDC-42A3-9474-1A3956D46DE8}\") = \"${YEAR}\", \"${YEAR}\", \"{${FOLDER_GUID}}\"\\nEndProject" "${SOLUTION_FILE}"
fi

# Check if project already exists in solution
if ! grep -q "${DAY_DIR}/${PROJECT_NAME}.csproj" "${SOLUTION_FILE}"; then
    # Add project reference
    sed -i "/^Global$/i Project(\"{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}\") = \"${PROJECT_NAME}\", \"${DAY_DIR}/${PROJECT_NAME}.csproj\", \"{${PROJECT_GUID}}\"\\nEndProject" "${SOLUTION_FILE}"
    
    # Add build configurations
    sed -i "/GlobalSection(ProjectConfigurationPlatforms) = postSolution/a \\\\t\\t{${PROJECT_GUID}}.Debug|Any CPU.ActiveCfg = Debug|Any CPU\\n\\\\t\\t{${PROJECT_GUID}}.Debug|Any CPU.Build.0 = Debug|Any CPU\\n\\\\t\\t{${PROJECT_GUID}}.Release|Any CPU.ActiveCfg = Release|Any CPU\\n\\\\t\\t{${PROJECT_GUID}}.Release|Any CPU.Build.0 = Release|Any CPU" "${SOLUTION_FILE}"
    
    # Add nested project (get folder GUID)
    FOLDER_GUID=$(grep -A 1 "\"${YEAR}\", \"${YEAR}\"" "${SOLUTION_FILE}" | grep -oP '\{[A-F0-9-]+\}' | head -1 | tr -d '{}')
    sed -i "/GlobalSection(NestedProjects) = preSolution/a \\\\t\\t{${PROJECT_GUID}} = {${FOLDER_GUID}}" "${SOLUTION_FILE}"
fi

echo "✅ Created Advent of Code ${YEAR} Day ${DAY}"
echo "📁 Directory: ${DAY_DIR}"
echo "📝 Files created:"
echo "   - ${DAY_DIR}/Program.cs"
echo "   - ${DAY_DIR}/${PROJECT_NAME}.csproj"
echo "   - ${DAY_DIR}/input.txt"
echo "   - ${DAY_DIR}/sample.txt"
echo ""
echo "🚀 To run: cd ${DAY_DIR} && dotnet run"