#!/usr/bin/env python

import requests
from bs4 import BeautifulSoup

def main():
    rsp = requests.get('https://www.nerdfonts.com/cheat-sheet')
    soup = BeautifulSoup(rsp.text, 'html.parser')

    columns = soup.find_all('div', attrs={'class': 'column'})
    icons = [(
        col.find('div', attrs={'class': 'codepoint'}).text,
        col.find('div', attrs={'class': 'class-name'}).text,
    ) for col in columns]

    print('-- stylua: ignore')
    print('return {')
    for code, name in icons:
        print('   {')
        print(f"        code = '{code}',")
        print(f"        icon = '{chr(int(code, 16))}',")
        print(f"        name = '{name}',")
        print('   },')
    print('}')


if __name__ == "__main__":
    main()
