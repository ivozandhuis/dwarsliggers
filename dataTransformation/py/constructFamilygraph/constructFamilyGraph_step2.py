#! /usr/bin/env python3
# Python3 script to construct familyrelations

import csv

# read personlist
lijst = []
with open('huwelijksakten_personen.csv', newline='') as infile:
    reader = csv.DictReader(infile)
    for inn in reader:
        lijst.append(inn)

# calculate network
edgelist = []
for A in lijst:
    for B in lijst:
        if (A['sleutel'] == B['sleutel'] and \
            A['my_medewerkersnummer'] != B['my_medewerkersnummer']):

            # vader-zoon
            if A['relatie'] == 'ouders1' and B['relatie'] == 'zelf':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zoon_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'zelf':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zoon_van'])
            if A['relatie'] == 'zelf' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'vader_van'])
            if A['relatie'] == 'zelf' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'vader_van'])

            # schoonvader-schoonzoon
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'zelf':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'schoonzoon_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'zelf':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'schoonzoon_van'])
            if A['relatie'] == 'zelf' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'schoonvader_van'])
            if A['relatie'] == 'zelf' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'schoonvader_van'])

            # broers
            if A['relatie'] == 'ouders1' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'broer_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'broer_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'broer_van'])
            if A['relatie'] == 'ouders1' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'broer_van'])

            # zwagers
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'ouders1' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'ouders1' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'zwager_van'])

            # ooms
            # let op! ook vaders worden als ooms gedetecteerd
            if A['relatie'] == 'ouders1' and B['relatie'] == 'oudersVader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders1' and B['relatie'] == 'oudersMoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders1' and B['relatie'] == 'oudersSchoonvader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders1' and B['relatie'] == 'oudersSchoonmoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'oudersVader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'oudersMoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'oudersSchoonvader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'ouders2' and B['relatie'] == 'oudersSchoonmoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'oudersVader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'oudersMoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'oudersSchoonvader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders1' and B['relatie'] == 'oudersSchoonmoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'oudersVader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'oudersMoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'oudersSchoonvader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])
            if A['relatie'] == 'schoonouders2' and B['relatie'] == 'oudersSchoonmoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oom_van'])


            # oomzeggers
            # let op! ook zonen worden als oomzeggers gedetecteerd
            if A['relatie'] == 'oudersVader' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersMoeder' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonvader' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonmoeder' and B['relatie'] == 'ouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersVader' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersMoeder' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonvader' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonmoeder' and B['relatie'] == 'ouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersVader' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersMoeder' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonvader' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonmoeder' and B['relatie'] == 'schoonouders1':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersVader' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersMoeder' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonvader' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])
            if A['relatie'] == 'oudersSchoonmoeder' and B['relatie'] == 'schoonouders2':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'oomzegger_van'])


            # neven
            # let op! ook broers worden als neven gedetecteerd!
            if A['relatie'] == 'oudersVader' and B['relatie'] == 'oudersVader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'neef_van'])
            if A['relatie'] == 'oudersVader' and B['relatie'] == 'oudersMoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'neef_van'])
            if A['relatie'] == 'oudersMoeder' and B['relatie'] == 'oudersVader':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'neef_van'])
            if A['relatie'] == 'oudersMoeder' and B['relatie'] == 'oudersMoeder':
                edgelist.append([A['my_medewerkersnummer'], B['my_medewerkersnummer'], 'neef_van'])

# ontdubbelen
new_edgelist = []
for edge in edgelist:
    if edge not in new_edgelist:
        new_edgelist.append(edge)
edgelist = new_edgelist

# verwijderen neven die al broer zijn; ooms die al (schoon)vader zijn; oomzeggers die al (schoon)zonen zijn
new_edgelist = []
for edgeA in edgelist:
    keep = 1
    if edgeA[2] == 'neef_van':
        for edgeB in edgelist:
            if  edgeB[0] == edgeA[0] and \
                edgeB[1] == edgeA[1] and \
                edgeB[2] == 'broer_van':
                keep = 0

    if edgeA[2] == 'oomzegger_van':
        for edgeB in edgelist:
            if  edgeB[0] == edgeA[0] and \
                edgeB[1] == edgeA[1] and \
                edgeB[2] == 'zoon_van':
                keep = 0

    if edgeA[2] == 'oomzegger_van':
        for edgeB in edgelist:
            if  edgeB[0] == edgeA[0] and \
                edgeB[1] == edgeA[1] and \
                edgeB[2] == 'schoonzoon_van':
                keep = 0

    if edgeA[2] == 'oom_van':
        for edgeB in edgelist:
            if  edgeB[0] == edgeA[0] and \
                edgeB[1] == edgeA[1] and \
                edgeB[2] == 'vader_van':
                keep = 0

    if edgeA[2] == 'oom_van':
        for edgeB in edgelist:
            if  edgeB[0] == edgeA[0] and \
                edgeB[1] == edgeA[1] and \
                edgeB[2] == 'schoonvader_van':
                keep = 0

    if keep:
        new_edgelist.append(edgeA)

edgelist = new_edgelist




# print/write etc.
resultfile = open('familynetwork.csv', 'w')
resultwriter = csv.writer(resultfile, delimiter=',', quotechar='"')
resultwriter.writerow(['source', 'target', 'famrel']) # header
for edge in edgelist:
	resultwriter.writerow(edge)
resultfile.close()
