#include <iostream>
#include <fstream>
#include <string>
using namespace std;
//#define DEBUG 1;
void binary5(ofstream &outfile, int reg2)
{
    int decimal = reg2, binary = 0, remainder, product = 1, DEBUG = 1;
    if (decimal == 1 || decimal == 0)
    {
        outfile << "000";
    }
    if (decimal > 1 && decimal < 4)
    {
        outfile << "00";
    }
    if (decimal <= 7 && decimal > 3)
    {
        outfile << "0";
    }
    while (decimal != 0)
    {
        remainder = decimal % 2;
        binary = binary + (remainder * product);
        decimal = decimal / 2;
        product *= 10;
    }
    if (DEBUG)
    {
        cout << "binary = " << binary << endl;
    }
    outfile << binary;
}
void binary(ofstream &outfile, int reg2)
{
    int decimal = reg2, binary = 0, remainder, product = 1, DEBUG = 1;
    if (decimal == 1 || decimal == 0)
    {
        outfile << "00";
    }
    if (decimal > 1 && decimal < 4)
    {
        outfile << "0";
    }
    while (decimal != 0)
    {
        remainder = decimal % 2;
        binary = binary + (remainder * product);
        decimal = decimal / 2;
        product *= 10;
    }
    if (DEBUG)
    {
        cout << "binary = " << binary << endl;
        ;
    }
    outfile << binary;
}
void readFile()
{
    int DEBUG = 1, temp;
    ifstream file;
    ifstream &in = file;
    file.open("test.txt");
    ofstream outfile("code.txt");
    ofstream &out = outfile;
    if (!file.is_open())
        return;
    string cmd, reg1, reg2, temp3;
    char temp1, temp2;
    while (file >> cmd)
    {
        if (DEBUG)
            cout << cmd << '\n';
        if (cmd == "LDR")
        {
            outfile << "000";
        }
        else if (cmd == "STR")
        {
            outfile << "001";
        }
        else if (cmd == "AND")
        {
            outfile << "010";
        }
        else if (cmd == "XOR")
        {
            outfile << "011";
        }
        else if (cmd == "ADD")
        {
            outfile << "100";
        }
        else if (cmd == "LSL")
        {
            outfile << "101000";
            file >> reg2;
            if (DEBUG)
                cout << reg2 << " reg2" << '\n';
            if (reg2 == "R0" || reg2 == "r0")
            {
                outfile << "000" << endl;
                continue;
            }
            else if (reg2 == "R1" || reg2 == "r1")
            {
                outfile << "001" << endl;
                continue;
            }
            else
            {
                temp1 = reg2[1];
                temp2 = reg2[2];
                temp3 = string() + temp1 + temp2;
                if (DEBUG)
                    cout << temp3 << " int" << '\n';
                binary(out, stoi(temp3));
                outfile << endl;
                continue;
            }
        }
        else if (cmd == "BEQ")
        {
            outfile << "110";
        }
        else if (cmd == "MOV")
        {
            file >> reg1;
            if (DEBUG)
                cout << reg1 << " reg1" << '\n';
            outfile << "111";
            // 111 00R Reg  Move value from Reg into the register #R (rather 1 or 0)
            if (reg1 == "R0" || reg1 == "r0")
            {
                outfile << "000";
            }
            else if (reg1 == "R1" || reg1 == "r1")
            {
                outfile << "001";
            }
            // 111 01R Reg  Move value from register #R (rather 1 or 0) into Reg
            else
            {
                outfile << "01";
                file >> reg2;
                if (DEBUG)
                    cout << reg2 << " reg2" << '\n';
                if (reg2 == "R0" || reg2 == "r0")
                {
                    outfile << "0";
                }
                else if (reg2 == "R1" || reg2 == "r1")
                {
                    outfile << "1";
                }
                temp1 = reg1[1];
                temp2 = reg1[2];
                temp3 = string() + temp1 + temp2;
                if (DEBUG)
                    cout << temp3 << " int" << '\n';
                binary(out, stoi(temp3));
                outfile << endl;
                continue;
            }
            file >> reg2;
            if (DEBUG)
                cout << reg2 << " reg2" << '\n';
            if (reg2 == "R0" || reg2 == "r0")
            {
                outfile << "000" << endl;
                continue;
            }
            else if (reg2 == "R1" || reg2 == "r1")
            {
                outfile << "001" << endl;
                continue;
            }
            else
            {
                temp1 = reg2[1];
                temp2 = reg2[2];
                temp3 = string() + temp1 + temp2;
                if (DEBUG)
                    cout << temp3 << " int" << '\n';
                binary(out, stoi(temp3));
                outfile << endl;
                continue;
            }
        }
        else if (cmd == "IMD")
        {
            outfile << "111";
            file >> reg1;
            if (DEBUG)
                cout << reg1 << " reg1" << '\n';
            if (reg1 == "LUT" || reg1 == "lut")
            {
                outfile << "11";
                file >> reg2;
                if (DEBUG)
                    cout << reg2 << " reg2" << '\n';
                temp1 = reg2[1];
                temp2 = reg2[2];
                temp3 = string() + temp1 + temp2;
                if (DEBUG)
                    cout << temp3 << " int" << '\n';
                binary5(out, stoi(temp3));
                outfile << endl;
                continue;
            }
            else
            {
                outfile << "10";
                temp1 = reg1[1];
                temp2 = reg1[2];
                temp3 = string() + temp1 + temp2;
                if (DEBUG)
                    cout << temp3 << " int" << '\n';
                binary5(out, stoi(temp3));
                outfile << endl;
                continue;
            }
        }
        file >> reg1;
        if (DEBUG)
            cout << reg1 << " reg1" << '\n';
        if (DEBUG)
            cout << reg2 << " reg2" << '\n';
        temp1 = reg1[1];
        temp2 = reg1[2];
        temp3 = string() + temp1 + temp2;
        if (DEBUG)
            cout << temp3 << " int" << '\n';
        binary(out, stoi(temp3));
        file >> reg2;
        temp1 = reg2[1];
        temp2 = reg2[2];
        temp3 = string() + temp1 + temp2;
        if (DEBUG)
            cout << temp3 << " int" << '\n';
        binary(out, stoi(temp3));
        outfile << endl;
        continue;
    }
}

int main()
{
    readFile();
    return 0;
}
