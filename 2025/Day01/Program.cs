// Read all lines from the input file
var input = File.ReadAllLines("input.txt");

// Parse the file content - split each line into two numbers
var leftNumbers = new List<int>();
var rightNumbers = new List<int>();

foreach (var line in input)
{
    var parts = line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);
    leftNumbers.Add(int.Parse(parts[0]));
    rightNumbers.Add(int.Parse(parts[1]));
}

// Print numbers
Console.WriteLine("Left numbers:");
foreach (var number in leftNumbers)
{
    Console.WriteLine(number);
}

Console.WriteLine("\nRight numbers:");
foreach (var number in rightNumbers)
{
    Console.WriteLine(number);
}