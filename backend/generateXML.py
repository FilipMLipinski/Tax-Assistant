import xml.dom.minidom

def generateXML(d):
    def wrap(name):
        if(name!='Data'):
            return "<" + name + ">" + d[name] + "</" + name + ">"
        else:
            return '<Data poz="P_4">' + d['Data'] + "</Data>"

    ret = '<?xml version="1.0" encoding="UTF-8"?><Deklaracja xmlns="http://crd.gov.pl/wzor/2023/12/13/13064/"><Naglowek><KodFormularza kodSystemowy="PCC-3 (6)" kodPodatku="PCC" rodzajZobowiazania="Z" wersjaSchemy="1-0E">PCC-3</KodFormularza><WariantFormularza>6</WariantFormularza><CelZlozenia poz="P_6">1</CelZlozenia>'
    ret = ret + wrap('Data')
    ret = ret + wrap('KodUrzedu')
    ret = ret + '</Naglowek><Podmiot1 rola="Podatnik"><OsobaFizyczna>'
    ret = ret + wrap('PESEL')
    ret = ret + wrap('ImiePierwsze')
    ret = ret + wrap('Nazwisko')
    ret = ret + wrap('DataUrodzenia')
    ret = ret + '</OsobaFizyczna><AdresZamieszkaniaSiedziby rodzajAdresu="RAD"><AdresPol>'
    ret = ret + wrap('KodKraju')
    ret = ret + wrap('Wojewodztwo')
    ret = ret + wrap('Powiat')
    ret = ret + wrap('Gmina')
    ret = ret + wrap('NrDomu')
    ret = ret + wrap('Miejscowosc')
    ret = ret + wrap('KodPocztowy')
    ret = ret + '</AdresPol></AdresZamieszkaniaSiedziby></Podmiot1><PozycjeSzczegolowe><P_7>1</P_7>'
    ret = ret + '</PozycjeSzczegolowe><Pouczenia>1</Pouczenia></Deklaracja>'

    dom = xml.dom.minidom.parseString(ret)
    pretty_xml = dom.toprettyxml(indent="  ")

    with open('output.xml', 'w', encoding='utf-8') as file:
        file.write(pretty_xml)

    return pretty_xml

