#! /usr/bin/env python3
# Python3 library for operations on openarch.nl using the openarch API
# see: https://api.openarch.nl/

import requests
import json
from time import sleep

#######
# searchDoc
# function to find events (plural!)
def searchDoc(personName, before, after, relationType):

    # API variables
    baseUrl = "https://api.openarch.nl/1.0/records/search.json?"
    lang = "nl"
    numberShow = 25

    # initialize variables for loop
    page = 0
    numberFound = 0
    result = []
    while (numberFound >= (page * numberShow)):
        start = page * numberShow
        reqUrl = baseUrl + \
                "name=" + personName + \
                "+" + str(after) + "-" + str(before) + \
                "&relationtype=" + relationType + \
                "&lang=" + lang + \
                "&number_show=" + str(numberShow) + \
                "&start=" + str(start)

        r = requests.get(reqUrl)
        print(reqUrl) # for debugging
        sleep(0.25) # prevent server overload
        jsonResultList = json.loads(r.text)

        numberFound = int(jsonResultList['response']['number_found'])
        end = numberFound - start
        if end > numberShow:
            end = numberShow

        for i in range(0,end):
            url = jsonResultList['response']['docs'][i]['url']
            result.append(url)

        page = page + 1

    return result


#######
# showDoc
# function to get a dict, created from A2A json
def showDoc(url):
    # if url is the human-readable landingpage, construct REST-url
    url = url.strip() # remove trailing spaces
    reqUrl = url.replace("https://www.openarch.nl/show.php","https://api.openarch.nl/1.0/records/show.json")

    # error handling
    if (reqUrl != ""):
        # do request
        r = requests.get(reqUrl)
        print(reqUrl) # for debugging and progress
        sleep(0.25) # prevent server overload
        jsonResult = json.loads(r.text)
    else:
        jsonResult = {}
        jsonResult['error_description'] = "empty url"

    # jsonResult should be a list of items
    # if jsonResult is of type 'dict', then jsonResult is an errormessage
    if type(jsonResult) is dict:
        # construct a processable jsonResult, that returns the errormessage as a "gebeurtenis"
        error = jsonResult
        z = {}
        z['a2a_Event']  = {}
        z['a2a_Event']['a2a_EventType'] = {}
        z['a2a_Event']['a2a_EventType']['a2a_EventType']  = error
        z['a2a_RelationEP'] = []
        z['a2a_Person']     = []
        jsonResult = []
        jsonResult.append(z)

    # process jsonResult
    row = {}
    row['url']    = url

    # handle Event-part of the A2A record
    a2aEvent       = jsonResult[0].get('a2a_Event', {})

    # get plaats
    a2aEventPlace  = a2aEvent.get('a2a_EventPlace', {})
    a2aPlace       = a2aEventPlace.get('a2a_Place', {})
    row['plaats']  = a2aPlace.get('a2a_Place', "")

    # get gebeurtenis
    a2aEventType       = a2aEvent.get('a2a_EventType', {})
    row['gebeurtenis'] = a2aEventType.get('a2a_EventType', "")

    # get jaar/maand/dag
    a2aEventDate = a2aEvent.get('a2a_EventDate', {})
    a2aYear      = a2aEventDate.get('a2a_Year', {})
    row['jaar']  = a2aYear.get('a2a_Year', "")
    a2aMonth     = a2aEventDate.get('a2a_Month', {})
    row['maand'] = a2aMonth.get('a2a_Month', "")
    a2aDay       = a2aEventDate.get('a2a_Day', {})
    row['dag']   = a2aDay.get('a2a_Day', "")

    # rollen
    roles = {}
    for r in jsonResult[0]['a2a_RelationEP']:
        keyref = r['a2a_PersonKeyRef']['a2a_PersonKeyRef']
        role   = r['a2a_RelationType']['a2a_RelationType']
        roles[keyref] = role.replace(" ","_")

    # persoonsnamen
    for p in jsonResult[0]['a2a_Person']:

        a2aPersonName = p.get('a2a_PersonName', {})

        keyref = p['pid']
        role = roles[keyref]

        key = "voornaam" + role
        a2aPersonNameFirstName = a2aPersonName.get('a2a_PersonNameFirstName', {})
        row[key] =  a2aPersonNameFirstName.get('a2a_PersonNameFirstName', "")

        key = "tussenvoegsel" + role
        a2aPersonNamePrefixLastName = a2aPersonName.get('a2a_PersonNamePrefixLastName', {})
        row[key] =  a2aPersonNamePrefixLastName.get('a2a_PersonNamePrefixLastName', "")

        key = "achternaam" + role
        a2aPersonNameLastName = a2aPersonName.get('a2a_PersonNameLastName', {})
        row[key] =  a2aPersonNameLastName.get('a2a_PersonNameLastName', "")

    return row
