#!/usr/bin/python

import os

raw_data_filepath = 'files/games.txt'
number_of_games_to_transfer = 10

lines = [line.rstrip('\n') for line in open(raw_data_filepath)]

print "Note: Read", len(lines), "Games from file:", raw_data_filepath

print "Note: Try to write", number_of_games_to_transfer, "games to MIF file"

# MIF File Generation

mif_filepath = './ROM.mif'

if os.path.exists(mif_filepath):
    print "Warning: MIF File already exists. Will be overwritten."

mif_file = open(mif_filepath, 'w')

mif_file.write("DEPTH=2048;\n")
mif_file.write("WIDTH=8;\n")
mif_file.write("\n")
mif_file.write("ADDRESS_RADIX=UNS;\n")
mif_file.write("DATA_RADIX=UNS;\n")
mif_file.write("\n")
mif_file.write("CONTENT BEGIN\n")

for addr in range(0, 2048):

    digit = '0'

    if addr <= number_of_games_to_transfer * 128:

        line_addr = addr//128
        line = lines[line_addr]
        char_addr = addr - line_addr*128

        if char_addr < 81:
            digit = line[char_addr]

        if digit == '.':
            digit = '0'

    mif_file.write("    " + str(addr) + ":" + digit + ";\n")

mif_file.write("END;")

print "MIF File successfully wrote to", mif_filepath
