# WinGetter

WinGetter is a PowerShell script that simplifies searching for and installing Windows software packages using the `winget` command line tool. It retrieves a list of available packages based on a user-provided search string, displays the results in a sortable grid view, and allows users to select and install multiple packages at once.

## Prerequisites

* Windows Package Manager (winget) must be installed on your system. You can download it from the [official GitHub repository](https://github.com/microsoft/winget-cli/releases).

## Installation

1. Download the `WinGetter.ps1` file from this repository.
2. Place the file in your desired location on your computer.

## Usage

1. Open PowerShell.
2. Navigate to the directory where you saved the `WinGetter.ps1` file.
3. Run the script with the following command:

<pre><div class="bg-black rounded-md mb-4"><div class="flex items-center relative text-gray-200 bg-gray-800 px-4 py-2 text-xs font-sans justify-between rounded-t-md"><span>powershell</span></div></div></pre>

<pre><div class="bg-black rounded-md mb-4"><div class="p-4 overflow-y-auto"><code class="!whitespace-pre hljs language-powershell">.\WinGetter.ps1 -SearchString "your_search_string"
</code></div></div></pre>

Replace `"your_search_string"` with the software name or a keyword you want to search for.

4. The script will display the search results in a grid view, where you can sort the list by Name, Id, Version, Match, or Source.
5. Select the packages you want to install and click 'OK'.
6. The script will automatically install the selected packages using the `winget` command.

## Contributing

If you'd like to contribute to this project, please submit a pull request, issue, or suggestion on GitHub.

## License

This project is licensed under the MIT License. See the [LICENSE](https://chat.openai.com/LICENSE) file for details.

## Acknowledgments

* Thanks to Microsoft for creating the Windows Package Manager (`winget`) and making it open-source.
* Thanks to the PowerShell community for providing valuable resources and support.
