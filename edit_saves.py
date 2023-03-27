# =============================================================================
# MIT License
# 
# Copyright (c) 2023 luckytyphlosion
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =============================================================================

import itertools
import struct
import pathlib
import errno

SRAM_START_OFFSET = 0x100
MASK_OFFSET = 0x1a34
GAME_NAME_OFFSET = 0x29e0
CHECKSUM_OFFSET = 0x29dc
NAVI_STATS_OFFSET = 0x52a8
SAVE_SIZE = 0x7c14

NAVI_STAT_FST_BARR = 0x6
NAVI_STAT_CUST_LEVEL = 0xa
NAVI_STAT_CHIP_CHARGE = 0x39 # doesn't directly control chip charge but deals with charge time
NAVI_STAT_MAX_BASE_HP = 0x3e
NAVI_STAT_CUR_HP = 0x40
NAVI_STAT_MAX_HP = 0x42
NAVI_STAT_CHIP_HEAL = 0x50

NAVI_STATS_SIZE = 0x60


PROTOMAN = 0
COLONEL = 1

# hp
# cust
# chip heal
# chip charge
# fstbarr

class Save:
    __slots__ = ("filename", "version", "navi_index", "hp", "cust", "chip_charge", "chip_heal", "fst_barr", "save_data", "save_data_first_0x100_bytes")

    def __init__(self, filename, version, navi_index, hp, cust, chip_charge=None, chip_heal=None, fst_barr=None):
        self.filename = filename
        self.version = version
        self.navi_index = navi_index
        self.hp = hp
        self.cust = cust
        self.chip_charge = chip_charge
        self.chip_heal = chip_heal
        self.fst_barr = fst_barr

    def read_in_save(self):
        with open(self.filename, "rb") as f:
            save_data_full = bytearray(f.read())
            self.save_data_first_0x100_bytes = save_data_full[:SRAM_START_OFFSET]
            self.save_data = save_data_full[SRAM_START_OFFSET:]

        self.mask_save()
        checksum, expected_checksum = self.calc_checksum_and_expected_checksum()

        if checksum != expected_checksum:
            raise RuntimeError(f"Expected: 0x{expected_checksum:08x}, Actual: 0x{checksum:08x}.")

    def mask_save(self):
        mask = self.save_data[MASK_OFFSET:MASK_OFFSET+4]
        mask_first_byte = mask[0]
    
        # "We only actually need to use the first byte of the mask, even though it's 32 bits long."
        for i in range(SAVE_SIZE):
            self.save_data[i] ^= mask_first_byte
    
        self.save_data[MASK_OFFSET:MASK_OFFSET+4] = mask

    def calc_checksum_and_expected_checksum(self):
        checksum = 0

        for byte in itertools.islice(self.save_data, SAVE_SIZE):
            checksum = (checksum + byte) & 0xffffffff

        expected_checksum = struct.unpack("<I", self.save_data[CHECKSUM_OFFSET:CHECKSUM_OFFSET+4])[0]
        for i in range(4):
            checksum = (checksum - self.save_data[CHECKSUM_OFFSET+i]) & 0xffffffff

        if self.version == PROTOMAN:
            checksum_version_offset = 0x72
        else:
            checksum_version_offset = 0x18

        checksum = (checksum + checksum_version_offset) & 0xffffffff

        return checksum, expected_checksum

    def write_save_to_file(self):
        checksum, expected_checksum = self.calc_checksum_and_expected_checksum()
        self.save_data[CHECKSUM_OFFSET:CHECKSUM_OFFSET+4] = struct.pack("<I", checksum)

        self.mask_save()

        pathlib.Path("output_saves").mkdir(exist_ok=True)
        save_filename = f"output_saves/{pathlib.Path(self.filename).name}"

        save_data_full = self.save_data_first_0x100_bytes + self.save_data

        try:
            with open(save_filename, "wb+") as f:
                f.write(save_data_full)
        except OSError as e:
            if e.errno == errno.EINVAL:
                print(f"Cannot write to {save_filename}, try closing any emulators/programs using the save.")

    def edit_save(self):
        # hp
        self.write_navi_stats_hword(self.hp, NAVI_STAT_MAX_BASE_HP)
        self.write_navi_stats_hword(self.hp, NAVI_STAT_CUR_HP)
        self.write_navi_stats_hword(self.hp, NAVI_STAT_MAX_HP)

        # cust
        self.write_navi_stats_byte(self.cust, NAVI_STAT_CUST_LEVEL)

        # chip charge info
        if self.chip_charge is not None:
            self.write_navi_stats_byte(self.chip_charge, NAVI_STAT_CHIP_CHARGE)

        # chip heal
        if self.chip_heal is not None:
            self.write_navi_stats_hword(self.chip_heal, NAVI_STAT_CHIP_HEAL)

        # fst barr
        if self.fst_barr is not None:
            self.write_navi_stats_byte(self.fst_barr, NAVI_STAT_FST_BARR)

    def write_navi_stats_byte(self, value_unpacked, value_offset):
        value = (value_unpacked,)
        self.write_navi_stats_value(value, value_offset, 1)

    def write_navi_stats_hword(self, value_unpacked, value_offset):
        value = struct.pack("<H", value_unpacked)
        self.write_navi_stats_value(value, value_offset, 2)

    def write_navi_stats_value(self, value, value_offset, size):
        cur_navi_stats_value_offset = NAVI_STATS_OFFSET + NAVI_STATS_SIZE * self.navi_index + value_offset
        self.save_data[cur_navi_stats_value_offset:cur_navi_stats_value_offset+size] = value

input_saves = (
    Save("input_saves/tp_protoman.sav", PROTOMAN, 1,
        hp=1200,
        cust=7,
        chip_charge=0x5),
    Save("input_saves/tp_gyroman.sav", PROTOMAN, 2,
        hp=1000,
        cust=6),
    Save("input_saves/tp_searchman.sav", PROTOMAN, 3,
        hp=1300,
        cust=6),
    Save("input_saves/tp_napalmman.sav", PROTOMAN, 4,
        hp=1250,
        cust=6),
    Save("input_saves/tp_magnetman.sav", PROTOMAN, 5,
        hp=1400,
        cust=6,
        fst_barr=1),
    Save("input_saves/tp_meddy.sav", PROTOMAN, 6,
        hp=1000,
        cust=7,
        chip_heal=30),
    Save("input_saves/tc_colonel.sav", COLONEL, 1,
        hp=1300,
        cust=8),
    Save("input_saves/tc_shadowman.sav", COLONEL, 2,
        hp=1150,
        cust=6,
        chip_charge=0x18),
    Save("input_saves/tc_numberman.sav", COLONEL, 3,
        hp=1000,
        cust=10),
    Save("input_saves/tc_tomahawkman.sav", COLONEL, 4,
        hp=1250,
        cust=6),
    Save("input_saves/tc_knightman.sav", COLONEL, 5,
        hp=1400,
        cust=6,
        chip_charge=0x12),
    Save("input_saves/tc_toadman.sav", COLONEL, 6,
        hp=1200,
        cust=7)
)

def main():
    for input_save in input_saves:
        input_save.read_in_save()
        input_save.edit_save()
        input_save.write_save_to_file()

if __name__ == "__main__":
    main()
