#! /usr/bin/env python3
# Python3 script to prepare construction of familyrelations from huwelijksakten

import csv

lijst = []

with open('~/git/dwarsliggers/data/sources/csv/huwelijksakten.csv', newline='') as infile:

    reader = csv.DictReader(infile)
    for inn in reader:
        if (inn['familierelatie'] == 'eigen'):
            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'zelf'
            out['manAchternaam']      = inn['achternaamBruidegom']
            out['manTussenvoegsel']   = inn['tussenvoegselBruidegom']
            out['manVoornaam']        = inn['voornaamBruidegom']
            out['vrouwAchternaam']    = inn['achternaamBruid']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselBruid']
            out['vrouwVoornaam']      = inn['voornaamBruid']
            lijst.append(out)

            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'ouders1'
            out['manAchternaam']      = inn['achternaamVader_van_de_bruidegom']
            out['manTussenvoegsel']   = inn['tussenvoegselVader_van_de_bruidegom']
            out['manVoornaam']        = inn['voornaamVader_van_de_bruidegom']
            out['vrouwAchternaam']    = inn['achternaamMoeder_van_de_bruidegom']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselMoeder_van_de_bruidegom']
            out['vrouwVoornaam']      = inn['voornaamMoeder_van_de_bruidegom']
            lijst.append(out)

            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'schoonouders1'
            out['manAchternaam']      = inn['achternaamVader_van_de_bruid']
            out['manTussenvoegsel']   = inn['tussenvoegselVader_van_de_bruid']
            out['manVoornaam']        = inn['voornaamVader_van_de_bruid']
            out['vrouwAchternaam']    = inn['achternaamMoeder_van_de_bruid']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselMoeder_van_de_bruid']
            out['vrouwVoornaam']      = inn['voornaamMoeder_van_de_bruid']
            lijst.append(out)

        if (inn['familierelatie'] == 'ouders'):
            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'ouders2'
            out['manAchternaam']      = inn['achternaamBruidegom']
            out['manTussenvoegsel']   = inn['tussenvoegselBruidegom']
            out['manVoornaam']        = inn['voornaamBruidegom']
            out['vrouwAchternaam']    = inn['achternaamBruid']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselBruid']
            out['vrouwVoornaam']      = inn['voornaamBruid']
            lijst.append(out)

            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'oudersVader'
            out['manAchternaam']      = inn['achternaamVader_van_de_bruidegom']
            out['manTussenvoegsel']   = inn['tussenvoegselVader_van_de_bruidegom']
            out['manVoornaam']        = inn['voornaamVader_van_de_bruidegom']
            out['vrouwAchternaam']    = inn['achternaamMoeder_van_de_bruidegom']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselMoeder_van_de_bruidegom']
            out['vrouwVoornaam']      = inn['voornaamMoeder_van_de_bruidegom']
            lijst.append(out)

            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'oudersMoeder'
            out['manAchternaam']      = inn['achternaamVader_van_de_bruid']
            out['manTussenvoegsel']   = inn['tussenvoegselVader_van_de_bruid']
            out['manVoornaam']        = inn['voornaamVader_van_de_bruid']
            out['vrouwAchternaam']    = inn['achternaamMoeder_van_de_bruid']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselMoeder_van_de_bruid']
            out['vrouwVoornaam']      = inn['voornaamMoeder_van_de_bruid']
            lijst.append(out)

        if (inn['familierelatie'] == 'schoonouders'):
            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'schoonouders2'
            out['manAchternaam']      = inn['achternaamBruidegom']
            out['manTussenvoegsel']   = inn['tussenvoegselBruidegom']
            out['manVoornaam']        = inn['voornaamBruidegom']
            out['vrouwAchternaam']    = inn['achternaamBruid']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselBruid']
            out['vrouwVoornaam']      = inn['voornaamBruid']
            lijst.append(out)

            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'oudersSchoonvader'
            out['manAchternaam']      = inn['achternaamVader_van_de_bruidegom']
            out['manTussenvoegsel']   = inn['tussenvoegselVader_van_de_bruidegom']
            out['manVoornaam']        = inn['voornaamVader_van_de_bruidegom']
            out['vrouwAchternaam']    = inn['achternaamMoeder_van_de_bruidegom']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselMoeder_van_de_bruidegom']
            out['vrouwVoornaam']      = inn['voornaamMoeder_van_de_bruidegom']
            lijst.append(out)

            out = {}
            out['my_medewerkersnummer'] = inn['my_medewerkersnummer']
            out['relatie']            = 'oudersSchoonmoeder'
            out['manAchternaam']      = inn['achternaamVader_van_de_bruid']
            out['manTussenvoegsel']   = inn['tussenvoegselVader_van_de_bruid']
            out['manVoornaam']        = inn['voornaamVader_van_de_bruid']
            out['vrouwAchternaam']    = inn['achternaamMoeder_van_de_bruid']
            out['vrouwTussenvoegsel'] = inn['tussenvoegselMoeder_van_de_bruid']
            out['vrouwVoornaam']      = inn['voornaamMoeder_van_de_bruid']
            lijst.append(out)

# add sleutel
for r in lijst:
     sleutel = r['manAchternaam'] + r['vrouwAchternaam']
     sleutel = sleutel.replace(' ','')
     # verwijder umlaut
     sleutel = sleutel.replace('ë','e')
     sleutel = sleutel.replace('ï','i')
     sleutel = sleutel.replace('ä','a')
     sleutel = sleutel.replace('ö','o')
     sleutel = sleutel.replace('ü','u')

     # verwijder streepjes
     sleutel = sleutel.replace('é','e')
     sleutel = sleutel.replace('è','e')
     sleutel = sleutel.replace('ç','c')

     sleutel = sleutel.upper()
     r['sleutel'] = sleutel

# save
outfile = open('huwelijksakten_personen.csv', 'w', newline='')
fieldnames = ['my_medewerkersnummer', \
            'relatie', \
            'sleutel', \
            'manAchternaam', \
            'manTussenvoegsel', \
            'manVoornaam', \
            'vrouwAchternaam', \
            'vrouwTussenvoegsel', \
            'vrouwVoornaam']
writer = csv.DictWriter(outfile, fieldnames=fieldnames, extrasaction='ignore')
writer.writeheader()
for r in lijst:
    if r['sleutel'] != '':
        writer.writerow(r)
