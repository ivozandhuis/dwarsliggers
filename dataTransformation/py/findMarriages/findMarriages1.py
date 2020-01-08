#! /usr/bin/env python3
# Python3 script to ... findmarriages

import openarchLib
import csv

# set up outputfile in csv
outfile = open('huwelijken_gehuwde_medewerkers_out.csv', 'w', newline='')
fieldnames = ['my_medewerkersnummer.x', \
                'voornaam.x', \
                'tussenvoegsel.x', \
                'achternaam.x', \
                'voornaam.y', \
                'tussenvoegsel.y', \
                'achternaam.y', \
                'voor', \
                'na', \
                'aktes']
writer = csv.DictWriter(outfile, fieldnames=fieldnames)
writer.writeheader()

# read and process every input
with open('huwelijken_gehuwde_medewerkers_in.csv', newline='') as infile:
    reader = csv.DictReader(infile)
    progress = 0
    for row in reader:

        ###
        # create searchterms
        bruidegom = row['voornaam.x']
        if (row['tussenvoegsel.x'] != ""):
                bruidegom = bruidegom + " " + row['tussenvoegsel.x']
        bruidegom = bruidegom + " " + row['achternaam.x']

        bruid = row['voornaam.y']
        if (row['tussenvoegsel.y'] != ""):
                bruid = bruid + " " + row['tussenvoegsel.y']
        bruid = bruid + " " + row['achternaam.y']

        voor      = int(row['voor'])
        na        = int(row['na'])

        ###
        # search bruidegom; res1 list of hits
        q = bruidegom + "+%2526~%2526+" + bruid
        res1 = openarchLib.searchDoc(q, voor, na, "Bruidegom")

        if (len(res1) == 0):
            # change bruidegom searchterm
            q = row['achternaam.x'] + "+%2526~%2526+" + bruid
            res1 = openarchLib.searchDoc(q, voor, na, "Bruidegom")

        if (len(res1) == 0):
            # change bruid searchterm
            q = bruidegom + "+%2526~%2526+" + row['achternaam.y']
            res1 = openarchLib.searchDoc(q, voor, na, "Bruidegom")

        ###
        # search bruid; res2 list of hits
        q = bruid + "+%2526~%2526+" + bruidegom
        res2 = openarchLib.searchDoc(q, voor, na, "Bruid")

        if (len(res2) == 0):
            # change bruid searchterm
            q = row['achternaam.y'] + "+%2526~%2526+" + bruidegom
            res2 = openarchLib.searchDoc(q, voor, na, "Bruid")

        if (len(res2) == 0):
            # change bruidegom searchterm
            q = bruid + "+%2526~%2526+" + row['achternaam.x']
            res2 = openarchLib.searchDoc(q, voor, na, "Bruid")

        ###
        # hits that are in both lists are right
        row['aktes'] = list(set(res1) & set(res2))

        print(row['aktes'])
        writer.writerow(row)
