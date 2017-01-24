#!env python

import os, sys, getopt, json

def read_file(file):
    cities = []
    with open (file, 'rt') as infile:
        for city in infile:
            data = city.split('\t')
            names = data[3].split(',');
            cities.append({'id': int(data[0]),
                    'name': data[1],
                    'alternate_names': names,
                    'coordinates': {'lat': float(data[4]), 'lng': float(data[5])},
                    'country': data[8],
                    'population:': int(data[14]),
                    'timezone': data[17]})
    return cities

def main(argv):
    help = 'jsonify.py -g geonamesexport.txt'
    test = False
    verbose = False
    try:
        opts, args = getopt.getopt(argv,"hvtg:",["geonames-file=",])
    except getopt.GetoptError:
        print help
        sys.exit(2)
 
    file = ''
    for opt, arg in opts:
        if opt == '-h':
            print help
            sys.exit()
        elif opt in ("-g", "--geonames-file"):
            file = arg
        elif opt == '-t':
            test = True
        elif opt == '-v':
            verbose = True
    if file == '':
        print "No file given, exiting!"
        sys.exit(1)
    print json.dumps(read_file(file), indent=4)

if __name__ == "__main__":
   main(sys.argv[1:])
   