from pathlib import Path
import re
import typing

ROOT = Path(__file__).parent.parent  # Assumed location is: root/tools/__file__
ADDONS = ROOT / 'TER_VASS' / 'addons'
RE_INCLUDE = re.compile(r'#include \"(?P<included_file>.*)\"')
RE_HEADER = re.compile(r"""
    ^ # Start of string/file (MULTILINE off)
    /\* # Comment open /*
    .*? # Everything until next...
    \*/ # Comment close */
    \n # Include linebreak afterwards
    """, flags=re.DOTALL | re.VERBOSE)
RE_SECTION_DESCRIPTION = re.compile(r"""
	\tDescription:\n # Start of section
	(?P<content> # Capture this part
	    (?:^\t\t.*\n)+ # All following lines starting with tab
    )
	""", flags=re.MULTILINE | re.VERBOSE)
RE_SECTION_AUTHORS = re.compile(r'Authors:\s*(?P<authors>.*)')

def generate_config_documentation():
    """
    Iterates over all addon files and adds/updates the header with the files
    that are included by and include this file. The description remains
    unchanged.
    """
    all_files = [x for x in ADDONS.glob(
        '**/*.*') if x.is_file() and not x.match('*.pbo')]
    includes, included_by = build_include_structure(all_files)
    for f in ADDONS.glob('**/*.hpp'):
        header = ['/*']
        header.append(f'\tHeader: {f.name}')
        header.append('')
        header.append('\tDescription:')
        file_content = f.read_text()
        # Try to extract old description
        try:
            description = re.search(
                RE_SECTION_DESCRIPTION, file_content)['content']
        except TypeError:
            description = "\t\tTODO\n"
        header.append(description)
        # Try to extract authors
        try:
            authors = re.search(RE_SECTION_AUTHORS, file_content)['authors']
        except TypeError:
            authors = 'Unknown'
        header.append('\tAuthors:')
        header.append(f'\t\t{authors}')
        header.append('')
        header.append('\tIncludes:')
        included_by_f = includes[f]  # Files that are included by file f
        if included_by_f == []:
            header.append('\t\tNone')
        else:
            for x in included_by_f:
                try:
                    header.append(f"\t\t- {x.relative_to(ADDONS)}")
                except ValueError:
                    header.append(f'\t\t- {x}')
        header.append('')
        header.append('\tIncluded by:')
        try:
            includes_f = included_by[f]  # Files that include file f
            if includes_f == []:
                header.append('\t\tNone')
            else:
                header.extend(
                    f"\t\t- {x.relative_to(ADDONS)}" for x in includes_f)
        except KeyError:
            pass
        header.append('*/\n')
        header = '\n'.join(header)
        if re.match(RE_HEADER, file_content):
            # Has header, remove old one
            file_content = re.sub(RE_HEADER, '', file_content)
        # print(header + file_content)
        f.write_text(header + file_content)
    return


def build_include_structure(files: typing.List[Path]) -> typing.Tuple[dict, dict]:
    """Set up the relationships between files. The result are two dictionaries
    with the file as a key. The first dictionary contains the files that are
    included by the key (file). The second one contains all the files that
    include the key (file).

    Args:
        files (List[Path]): The files which should be set in relation

    Returns:
        dict, dict: "Includes" and "included by" dictionaries
    """
    includes = {}
    included_by = {}
    for f in files:
        content = f.read_text()
        includes[f] = []
        for match in re.finditer(RE_INCLUDE, content):
            included_file = Path(match['included_file'])
            if not included_file.root:  # Relative include, absolute ones start with a slash
                file_dir = f.parent
                while included_file.parts[0] == '..': # Relative include from upper directory
                    included_file = included_file.relative_to('..')
                    file_dir = file_dir.parent
                included_file = file_dir / included_file
            elif included_file.parts[1:4] == ('z', 'TER_VASS', 'addons'):
                # Absolute include from this mod, like "\z\TER_VASS\addons\..."
                included_file = ADDONS / \
                    Path("/".join(included_file.parts[4:]))
            includes[f].append(included_file)
            try:
                included_by[included_file].append(f)  # Add to existing list
            except KeyError:
                included_by[included_file] = [f]  # Create new list for file
    return includes, included_by


generate_config_documentation()
