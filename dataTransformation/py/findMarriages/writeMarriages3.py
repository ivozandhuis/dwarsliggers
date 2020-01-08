#! /usr/bin/env python3
# writeMarriages.py

import openarchLib
import csv

# set up outputfile in csv
outfile = open('huwelijken_ouders_gehuwde_medewerkers.csv', 'w', newline='')
fieldnames = ['my_medewerkersnummer', \
                'url', \
                'gebeurtenis', \
                'plaats', \
                'jaar', \
                'maand', \
                'dag', \
                'voornaamBruidegom', \
                'tussenvoegselBruidegom', \
                'achternaamBruidegom', \
                'voornaamBruid', \
                'tussenvoegselBruid', \
                'achternaamBruid', \
                'voornaamVader_van_de_bruidegom', \
                'tussenvoegselVader_van_de_bruidegom', \
                'achternaamVader_van_de_bruidegom', \
                'voornaamMoeder_van_de_bruidegom', \
                'tussenvoegselMoeder_van_de_bruidegom', \
                'achternaamMoeder_van_de_bruidegom', \
                'voornaamVader_van_de_bruid', \
                'tussenvoegselVader_van_de_bruid', \
                'achternaamVader_van_de_bruid', \
                'voornaamMoeder_van_de_bruid', \
                'tussenvoegselMoeder_van_de_bruid', \
                'achternaamMoeder_van_de_bruid' ]

writer = csv.DictWriter(outfile, fieldnames=fieldnames, extrasaction='ignore')
writer.writeheader()

# read and process every input
with open('huwelijken_ouders_gehuwde_medewerkers_out.csv', newline='') as infile:
    reader = csv.DictReader(infile)
    for row in reader:
        url = row['aktes'].strip()
        r = openarchLib.showDoc(url)
        r['my_medewerkersnummer'] = row['my_medewerkersnummer']

        writer.writerow(r)
