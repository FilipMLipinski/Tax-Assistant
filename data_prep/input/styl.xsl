<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pf="http://crd.gov.pl/wzor/2023/12/13/13064/" version="1.0">
	<xsl:import href="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2023/10/18/eD/DefinicjeSzablony/Posredni_wspolne_v15-0E.xsl"/>
	<xsl:import href="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2022/09/13/eD/ORDZU/ORD-ZU(3)_v14-0E.xsl"/>
	<xsl:output method="html" encoding="UTF-8" indent="yes" version="4.01" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>
	<xsl:template name="TytulDokumentu">DEKLARACJA W SPRAWIE PODATKU OD CZYNNOŚCI CYWILNOPRAWNYCH</xsl:template>
	<xsl:template name="StyleDlaFormularza">
		<style type="text/css">
			.tlo-formularza {background-color: #D3D3D3; font-size:1.0em;}
			.pogrubiane { border: 3px solid black;}
			.niewypelnianeopisy {font-weight: bold}
			.niewypelnianeopisyright {
				background-color: #DDDDDD;
				border: 1px solid black;
				font-size: 1.2em;
				font-weight: bold;
				padding: 1px; 
				height: 2em;
				vertical-align: top;
				text-align: right;
				}
		</style>
	</xsl:template>
	<xsl:template match="pf:Deklaracja">
		<div class="deklaracja">
			<xsl:call-template name="NaglowekTechniczny">
				<xsl:with-param name="naglowek" select="pf:Naglowek"/>
				<xsl:with-param name="uzycie" select="'deklaracja'"/>
			</xsl:call-template>
			<xsl:call-template name="NaglowekTytulowy">
				<xsl:with-param name="naglowek" select="pf:Naglowek"/>
				<xsl:with-param name="uzycie" select="'deklaracja'"/>
				<xsl:with-param name="nazwa">DEKLARACJA W SPRAWIE PODATKU OD CZYNNOŚCI CYWILNOPRAWNYCH</xsl:with-param>
				<xsl:with-param name="podstawy-prawne">
					<table>
						<tr>
							<td class="etykieta" style="width: 10%">Podstawa prawna:</td>
							<td class="wartosc">Art. 10 ust. 1 ustawy z dnia 9 września 2000 r. o podatku od czynności cywilnoprawnych (Dz. U. z 2023 r. poz. 170, 1463 i 1723), zwanej
dalej „ustawą”.</td>
						</tr>
						<tr>
							<td class="etykieta" valign="top">Składający:</td>
							<td class="wartosc">Podatnicy podatku od czynności cywilnoprawnych.</td>
						</tr>
						<tr>
							<td class="etykieta">Termin składania:</td>
							<td class="wartosc">14 dni od dnia powstania obowiązku podatkowego.</td>
						</tr>
						<tr>
							<td class="etykieta">Miejsce składania:</td>
							<td class="wartosc">Urząd skarbowy, przy pomocy którego swoje zadania wykonuje naczelnik urzędu skarbowego, o którym mowa w art. 12 i 13 ustawy.</td>
						</tr>
					</table>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="MiejsceICel">
				<xsl:with-param name="sekcja">A.</xsl:with-param>
			</xsl:call-template>
			<xsl:for-each select="pf:Podmiot1">
				<xsl:call-template name="PodmiotPCC">
					<xsl:with-param name="sekcja">B.</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<!-- Pozycje Szczegolowe -->
			<xsl:call-template name="PrzedmiotOpodatkowania">
				<xsl:with-param name="sekcja">C.</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="ObliczeniePodatkuOdCzynnosciCywilnoprawnych">
				<xsl:with-param name="sekcja">D.</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="ObliczenieNaleznegoPodatkuOdUmowySpolki">
				<xsl:with-param name="sekcja">E.</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="PodatekDoZaplaty">
				<xsl:with-param name="sekcja">F.</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="InformacjeDodatkowe">
				<xsl:with-param name="sekcja">G.</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="InformacjaOZalacznikach">
				<xsl:with-param name="sekcja">H.</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="ObjasnieniaPCC3"/>
			<xsl:call-template name="PouczeniaPCC3"/>
		</div>
		<!-- deklaracja-->
		<xsl:apply-templates select="pf:Zalaczniki"/>
	</xsl:template>
	<xsl:template name="MiejsceICel">
		<xsl:param name="sekcja"/>
		<h2 class="tytul-sekcja-blok">
			<xsl:value-of select="$sekcja"/> MIEJSCE I CEL SKŁADANIA DEKLARACJI
		</h2>
		<table class="normalna">
			<tr>
				<td class="niewypelnianeopisy" style="width:33%">
					Urząd skarbowy, do którego jest adresowana deklaracja<sup>1)</sup>
				</td>
				<td class="wypelniane" style="width:auto">
					<div>
						<xsl:apply-templates select="*[local-name()='Naglowek']/*[local-name()='KodUrzedu']"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="niewypelnianeopisy">Cel złożenia deklaracji:</td>
				<td class="wypelniane">
					<xsl:choose>
						<xsl:when test="*[local-name()='Naglowek']/*[local-name()='CelZlozenia'] = '1'">
							<input type="checkbox" checked="checked" disabled="disabled"/>1. złożenie deklaracji
						</xsl:when>
						<xsl:when test="*[local-name()='Naglowek']/*[local-name()='CelZlozenia'] = '2'">
							<input type="checkbox" checked="checked" disabled="disabled"/>2. korekta deklaracji<sup>2)</sup>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="PodmiotPCC">
		<xsl:param name="sekcja"/>
		<h2 class="tytul-sekcja-blok">
			<xsl:value-of select="$sekcja"/> DANE PODATNIKA DOKONUJĄCEGO ZAPŁATY LUB ZWOLNIONEGO Z PODATKU NA PODSTAWIE ART. 9 PKT 10 LIT. B USTAWY</h2>
		<h3 class="tytul-sekcja-blok">
			<xsl:value-of select="$sekcja"/>1. DANE IDENTYFIKACYJNE</h3>
		<div class="sekcja">
			<xsl:for-each select="//pf:PozycjeSzczegolowe">
				<table class="normalna">
					<tr>
						<td class=" wypelniane">
							<div class="opisrubryki">7. Podmiot składający deklarację:</div>
							<xsl:variable name="wartosc1" select="pf:P_7"/>
							<xsl:choose>
								<xsl:when test="$wartosc1 ='1'">
									<input type="checkbox" checked="checked" disabled="disabled"/>1. podmiot zobowiązany solidarnie do zapłaty podatku
				</xsl:when>
								<xsl:when test="$wartosc1 ='2'">
									<input type="checkbox" checked="checked" disabled="disabled"/>2. strona umowy zamiany
				</xsl:when>
								<xsl:when test="$wartosc1 ='3'">
									<input type="checkbox" checked="checked" disabled="disabled"/>3. wspólnik spółki cywilnej
				</xsl:when>
								<xsl:when test="$wartosc1 ='4'">
									<input type="checkbox" checked="checked" disabled="disabled"/>4. podmiot, o którym mowa w art. 9 pkt 10 lit. b ustawy (pożyczkobiorca)
			</xsl:when>
								<xsl:when test="$wartosc1 ='5'">
									<input type="checkbox" checked="checked" disabled="disabled"/>5. inny podmiot
				</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</table>
			</xsl:for-each>
			<table class="normalna">
				<tr>
					<td class=" wypelniane">
						<div class="opisrubryki">8. Rodzaj podatnika:</div>
						<xsl:if test="*[local-name() = 'OsobaNiefizyczna']">
							<input type="checkbox" checked="checked" disabled="disabled"/>1. podatnik niebędący osobą fizyczną
						</xsl:if>
						<xsl:if test="*[local-name() = 'OsobaFizyczna']">
							<input type="checkbox" checked="checked" disabled="disabled"/>2. osoba fizyczna
						</xsl:if>
					</td>
				</tr>
			</table>
			<xsl:if test="*[local-name() = 'OsobaFizyczna']">
				<xsl:for-each select="*[local-name() = 'OsobaFizyczna']">
					<div class="sekcja">
						<table class="normalna">
							<tr>
								<xsl:if test="*[local-name()='NIP' ]">
									<td class="wypelniane">
										<div class="opisrubryki">Identyfikator podatkowy NIP</div>
										<xsl:apply-templates select="*[local-name() = 'NIP']"/>
									</td>
								</xsl:if>
								<xsl:if test="*[local-name()='PESEL' ]">
									<td class="wypelniane">
										<div class="opisrubryki">Identyfikator podatkowy numer PESEL</div>
										<xsl:apply-templates select="*[local-name() = 'PESEL']"/>
									</td>
								</xsl:if>
							</tr>
						</table>
					</div>
					<table class="normalna">
						<tr>
							<td class="wypelniane" style="width:40%">
								<div class="opisrubryki">Nazwisko</div>
								<xsl:apply-templates select="*[local-name()='Nazwisko']"/>
							</td>
							<td class="wypelniane" style="width:40%">
								<div class="opisrubryki">Pierwsze imię</div>
								<xsl:apply-templates select="*[local-name()='ImiePierwsze']"/>
							</td>
							<td class="wypelniane" style="width:20%">
								<div class="opisrubryki">Data urodzenia</div>
								<xsl:apply-templates select="*[local-name()='DataUrodzenia']"/>
							</td>
						</tr>
					</table>
					<xsl:if test="*[local-name()='ImieOjca' or local-name()='ImieMatki']">
						<table class="normalna">
							<tr>
								<xsl:if test="*[local-name()='ImieOjca' or local-name()='ImieMatki']">
									<td class="wypelniane">
										<div class="opisrubryki">Imię ojca</div>
										<xsl:apply-templates select="*[local-name() = 'ImieOjca']"/>
									</td>
									<td class="wypelniane">
										<div class="opisrubryki">Imię matki</div>
										<xsl:apply-templates select="*[local-name() = 'ImieMatki']"/>
									</td>
								</xsl:if>
							</tr>
						</table>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="*[local-name() = 'OsobaNiefizyczna']">
				<xsl:for-each select="*[local-name() = 'OsobaNiefizyczna']">
					<table class="normalna">
						<tr>
							<td class="wypelniane">
								<div class="opisrubryki">Identyfikator podatkowy NIP</div>
								<xsl:apply-templates select="*[local-name()='NIP']"/>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="wypelniane">
								<div class="opisrubryki">Nazwa pełna</div>
								<xsl:apply-templates select="*[local-name()='PelnaNazwa']"/>
							</td>
						</tr>
						<xsl:if test="*[local-name()='SkroconaNazwa']">
							<tr>
								<td colspan="2" class="wypelniane">
									<div class="opisrubryki">Nazwa skrócona</div>
									<xsl:apply-templates select="*[local-name()='SkroconaNazwa']"/>
								</td>
							</tr>
						</xsl:if>
					</table>
				</xsl:for-each>
			</xsl:if>
			<xsl:call-template name="AdresZamieszkaniaSiedziby1">
				<xsl:with-param name="sekcja">B.</xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="AdresZamieszkaniaSiedziby1">
		<xsl:param name="sekcja"/>
		<h3 class="tytul-sekcja-blok">
			<xsl:value-of select="$sekcja"/>2. ADRES SIEDZIBY / AKTUALNY ADRES ZAMIESZKANIA</h3>
		<div class="sekcja">
			<xsl:for-each select="*[local-name()='AdresZamieszkaniaSiedziby']">
				<xsl:apply-templates select="*[local-name()='AdresPol'] |*[local-name()='AdresZagr']"/>
			</xsl:for-each>
		</div>
	</xsl:template>
	<xsl:template match="*[local-name()='AdresPol'] | *[local-name()='AdresZagr']">
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Kraj</div>
					<xsl:apply-templates select="*[local-name()='KodKraju']"/>
				</td>
				<td class="wypelniane" style="width:40%">
					<div class="opisrubryki">Województwo</div>
					<xsl:apply-templates select="*[local-name()='Wojewodztwo']"/>
				</td>
				<td class="wypelniane" style="width:40%">
					<div class="opisrubryki">Powiat</div>
					<xsl:apply-templates select="*[local-name()='Powiat']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane" style="width:35%">
					<div class="opisrubryki">Gmina</div>
					<xsl:apply-templates select="*[local-name()='Gmina']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Ulica</div>
					<xsl:apply-templates select="*[local-name()='Ulica']"/>
				</td>
				<td class="wypelniane" style="width:10%">
					<div class="opisrubryki">Nr domu</div>
					<xsl:apply-templates select="*[local-name()='NrDomu']"/>
				</td>
				<td class="wypelniane" style="width:10%">
					<div class="opisrubryki">Nr lokalu</div>
					<xsl:apply-templates select="*[local-name()='NrLokalu']"/>
				</td>
			</tr>
		</table>
		<table class="normalna">
			<tr>
				<td class="wypelniane">
					<div class="opisrubryki">Miejscowość</div>
					<xsl:apply-templates select="*[local-name()='Miejscowosc']"/>
				</td>
				<td class="wypelniane">
					<div class="opisrubryki">Kod pocztowy</div>
					<xsl:apply-templates select="*[local-name()='KodPocztowy']"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="PrzedmiotOpodatkowania">
		<xsl:param name="sekcja"/>
		<xsl:for-each select="pf:PozycjeSzczegolowe">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> PRZEDMIOT OPODATKOWANIA I TREŚĆ CZYNNOŚCI CYWILNOPRAWNEJ</h2>
			<table class="normalna">
				<tr>
					<td class=" wypelniane">
						<div class="opisrubryki">20. Przedmiot opodatkowania:</div>
						<xsl:variable name="wartosc1" select="pf:P_20"/>
						<xsl:choose>
							<xsl:when test="$wartosc1 ='1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>1. umowa
				</xsl:when>
							<xsl:when test="$wartosc1 ='2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>2. zmiana umowy
				</xsl:when>
							<xsl:when test="$wartosc1 ='3'">
								<input type="checkbox" checked="checked" disabled="disabled"/>3. orzeczenie sądu lub ugoda
				</xsl:when>
							<xsl:when test="$wartosc1 ='4'">
								<input type="checkbox" checked="checked" disabled="disabled"/>4. inne
				</xsl:when>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td class=" wypelniane">
						<div class="opisrubryki">21. Miejsce położenia rzeczy lub miejsce wykonywania prawa majątkowego:</div>
						<xsl:variable name="wartosc2" select="pf:P_21"/>
						<xsl:choose>
							<xsl:when test="$wartosc2 ='1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>1. terytorium RP
				</xsl:when>
							<xsl:when test="$wartosc2 ='2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>2. poza terytorium RP
				</xsl:when>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td class=" wypelniane">
						<div class="opisrubryki">22. Miejsce dokonania czynności cywilnoprawnej:</div>
						<xsl:variable name="wartosc3" select="pf:P_22"/>
						<xsl:choose>
							<xsl:when test="$wartosc3 ='1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>1. terytorium RP
					</xsl:when>
							<xsl:when test="$wartosc3 ='2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>2. poza terytorium RP
					</xsl:when>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td class="wypelniane" style="width: 50%">
						<div class="opisrubryki">23. Zwięzłe określenie treści i przedmiotu czynności cywilnoprawnej</div>
						<xsl:value-of select="pf:P_23"/>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ObliczeniePodatkuOdCzynnosciCywilnoprawnych">
		<xsl:param name="sekcja"/>
		<xsl:for-each select="pf:PozycjeSzczegolowe">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> OBLICZENIE NALEŻNEGO PODATKU OD CZYNNOŚCI CYWILNOPRAWNYCH, Z WYJĄTKIEM UMOWY SPÓŁKI LUB JEJ ZMIANY</h2>
			<table class="normalna">
				<tr>
					<td class="niewypelniane" style="width: 40%">
						Rodzaj czynności cywilnoprawnej
						<font style="font-weight: normal">
							<br/>(w tym zmiana umowy, orzeczenie sądu lub ugoda)
						</font>
					</td>
					<td class="niewypelniane" style="width: 25%">
						Podstawa opodatkowania
						<font style="font-weight: normal">
							<br/>określona zgodnie z art. 6 ustawy<br/>(po zaokrągleniu do pełnych złotych)
						</font>
					</td>
					<td class="niewypelniane" style="width: 10%">
						Stawka podatku
						<font style="font-weight: normal">
							<br/>określona zgodnie z art. 7 ustawy
						</font>
					</td>
					<td class="niewypelniane" style="width: 25%">
						Obliczony należny podatek od czynności cywilnoprawnej
						<font style="font-weight: normal">
							<br/>(po zaokrągleniu do pełnych złotych)
						</font>
					</td>
				</tr>
				<tr>
					<td class="niewypelniane" style="font-weight: normal">a</td>
					<td class="niewypelniane" style="font-weight: normal">b</td>
					<td class="niewypelniane" style="font-weight: normal">c</td>
					<td class="niewypelniane" style="font-weight: normal">d</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 35%" rowspan="2">Umowa sprzedaży<sup>3)</sup>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">24.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_24)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="niewypelnianeopisy" style="width: 12%">
						<h1>
							<div align="right">1%</div>
						</h1>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">25.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_25)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<td class="wypelniane" style="width: 12%">
					<div class="opisrubryki">26.</div>
					<div class="kwota">
						<xsl:call-template name="TransformataKwotyPLN">
							<xsl:with-param name="kwota" select="string(pf:P_26)"/>
							<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
						</xsl:call-template>
					</div>
				</td>
				<td class="niewypelnianeopisy" style="width: 12%">
					<h1>
						<div align="right">2%</div>
					</h1>
				</td>
				<td class="wypelniane" style="width: 12%">
					<div class="opisrubryki">27.</div>
					<div class="kwota">
						<xsl:call-template name="TransformataKwotyPLN">
							<xsl:with-param name="kwota" select="string(pf:P_27)"/>
							<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
						</xsl:call-template>
					</div>
				</td>
				<tr>
					<td class="niewypelnianeopisy" style="width: 35%">Umowa zamiany</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">28.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_28)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">29.</div>
						<div class="kwota">
							<xsl:value-of select="pf:P_29"/>%
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">30.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_30)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 35%">Umowa pożyczki lub depozytu nieprawidłowego, w tym zwolniona na podstawie art. 9 pkt 10 lit. b ustawy<sup>4)</sup>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">31.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_31)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">32.</div>
						<div class="kwota">
							<xsl:value-of select="pf:P_32"/>%
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">33.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_33)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 35%">Umowa darowizny w części dotyczącej przejęcia przez obdarowanego długów i ciężarów lub zobowiązań darczyńcy</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">34.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_34)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">35.</div>
						<div class="kwota">
							<xsl:value-of select="pf:P_35"/>%
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">36.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_36)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 35%">Ustanowienie odpłatnego użytkowania, w tym nieprawidłowego</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">37.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_37)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">38.</div>
						<div class="kwota">
							<xsl:value-of select="pf:P_38"/>%
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">39.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_39)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 35%" rowspan="2">Ustanowienie hipoteki<sup>5)</sup>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">40.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_40)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="niewypelnianeopisy" style="width: 12%">
						<h1>
							<div align="right">0,1%</div>
						</h1>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">41.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_41)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 12%">
						<h1>
							<div align="center">1</div>
						</h1>
					</td>
					<td class="niewypelnianeopisyright" style="width: 12%">
							19 zł
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">42.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_42)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="wypelniane" style="width: 35%">
						<div class="opisrubryki">Inna <font style="font-weight: normal">(wymienić jaka):</font>
						</div>
						<xsl:value-of select="pf:P_43A"/>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">43.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_43)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">44.</div>
						<div class="kwota">
							<xsl:value-of select="pf:P_44"/>%
							
						</div>
					</td>
					<td class="wypelniane" style="width: 12%">
						<div class="opisrubryki">45.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_45)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
			</table>
			<table class="normalna">
				<tr>
					<td class="niewypelnianeopisy" style="width: 74%">Kwota należnego podatku
					<font style="font-weight: normal">
							<br/>Suma kwot z kolumny d.
						</font>
					</td>
					<td class="wypelniane" style="width: 26%">
						<div class="opisrubryki">46.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_46)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ObliczenieNaleznegoPodatkuOdUmowySpolki">
		<xsl:param name="sekcja"/>
		<h2 class="tytul-sekcja-blok">
			<xsl:value-of select="$sekcja"/> OBLICZENIE NALEŻNEGO PODATKU OD UMOWY SPÓŁKI / ZMIANY UMOWY SPÓŁKI</h2>
		<xsl:for-each select="pf:PozycjeSzczegolowe">
			<h3 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/>1. OKREŚLENIE PODSTAWY OPODATKOWANIA</h3>
			<table class="normalna">
				<xsl:variable name="wartosc1" select="pf:P_47"/>
				<tr>
					<td class=" wypelniane">
						<div class="opisrubryki">47. Typ spółki:</div>
						<xsl:choose>
							<xsl:when test="$wartosc1='1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>1. spółka osobowa
				</xsl:when>
							<xsl:when test="$wartosc1='2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>2. spółka kapitałowa
				</xsl:when>
							<xsl:otherwise>
								<div class="opisrubryki"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</table>
			<table class="normalna">
				<xsl:variable name="wartosc2" select="pf:P_48"/>
				<tr>
					<td class=" wypelniane">
						<div class="opisrubryki">48. Podstawa opodatkowania dotyczy:</div>
						<xsl:choose>
							<xsl:when test="$wartosc2='1'">
								<input type="checkbox" checked="checked" disabled="disabled"/>1. zawarcia umowy spółki
				</xsl:when>
							<xsl:when test="$wartosc2='2'">
								<input type="checkbox" checked="checked" disabled="disabled"/>2. zwiększenia majątku spółki albo podwyższenia kapitału zakładowego
				</xsl:when>
							<xsl:when test="$wartosc2='3'">
								<input type="checkbox" checked="checked" disabled="disabled"/>3. dopłaty
				</xsl:when>
							<xsl:when test="$wartosc2='4'">
								<input type="checkbox" checked="checked" disabled="disabled"/>4. pożyczki udzielonej spółce osobowej przez wspólnika
				</xsl:when>
							<xsl:when test="$wartosc2=5">
								<input type="checkbox" checked="checked" disabled="disabled"/>5. oddania spółce rzeczy lub praw majątkowych do nieodpłatnego używania
				</xsl:when>
							<xsl:when test="$wartosc2='6'">
								<input type="checkbox" checked="checked" disabled="disabled"/>6. przekształcenia spółek
				</xsl:when>
							<xsl:when test="$wartosc2='7'">
								<input type="checkbox" checked="checked" disabled="disabled"/>7. łączenia spółek
				</xsl:when>
							<xsl:when test="$wartosc2='8'">
								<input type="checkbox" checked="checked" disabled="disabled"/>8. przeniesienia na terytorium Rzeczypospolitej Polskiej rzeczywistego ośrodka zarządzania spółki kapitałowej lub jej siedziby
				</xsl:when>
							<xsl:otherwise>
								<div class="opisrubryki"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</table>
			<table class="normalna">
				<tr>
					<td class="niewypelnianeopisy" style="width: 80%">Podstawa opodatkowania - określona zgodnie z art. 6 ust. 1 pkt 8 ustawy
					<font style="font-weight: normal">
							(po zaokrągleniu do pełnych złotych)
					</font>
					</td>
					<td class="wypelniane" style="width: 20%">
						<div class="opisrubryki">49.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_49)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
			</table>
			<h3 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/>2. ODLICZENIA OD PODSTAWY OPODATKOWANIA - ART. 6 UST. 9 USTAWY</h3>
			<table class="normalna">
				<tr>
					<td class="niewypelnianeopisy" style="width: 80%">Opłaty i koszty związane z zawarciem umowy spółki lub jej zmiany – na podstawie art. 6 ust. 9 ustawy</td>
					<td class="wypelniane" style="width: 20%">
						<div class="opisrubryki">50.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_50)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="0"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
			</table>
			<h3 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/>3. OBLICZENIE NALEŻNEGO PODATKU</h3>
			<table class="normalna">
				<tr>
					<td class="niewypelnianeopisy" style="width: 80%">Podstawa obliczenia podatku
						<font style="font-weight: normal">
							<br/>Od kwoty z poz. 49 należy odjąć kwotę z poz. 50. Jeżeli różnica jest liczbą ujemną, należy wpisać 0.
						</font>
					</td>
					<td class="wypelniane" style="width: 20%">
						<div class="opisrubryki">51.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_51)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="0"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
				<tr>
					<td class="niewypelnianeopisy" style="width: 80%">Kwota należnego podatku
						<font style="font-weight: normal">
							(po zaokrągleniu do pełnych złotych)
							<br/>Podatek obliczony według stawki określonej w art. 7 ust. 1 pkt 9 ustawy od podstawy z poz. 51.
						</font>
					</td>
					<td class="wypelniane" style="width: 20%">
						<div class="opisrubryki">52.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_52)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PodatekDoZaplaty">
		<xsl:param name="sekcja"/>
		<xsl:for-each select="pf:PozycjeSzczegolowe">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> PODATEK DO ZAPŁATY</h2>
			<table class="normalna">
				<tr>
					<td class="niewypelnianeopisy" style="width: 80%">Kwota podatku do zapłaty
						<font style="font-weight: normal">
							<br/>Należy wpisać kwotę z poz. 46 albo 52.
						</font>
					</td>
					<td class="wypelniane pogrubiane" style="width: 20%">
						<div class="opisrubryki">53.</div>
						<div class="kwota">
							<xsl:call-template name="TransformataKwotyPLN">
								<xsl:with-param name="kwota" select="string(pf:P_53)"/>
								<xsl:with-param name="czyKwotaZaokraglona" select="1"/>
							</xsl:call-template>
						</div>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="InformacjeDodatkowe">
		<xsl:param name="sekcja"/>
		<xsl:for-each select="pf:PozycjeSzczegolowe">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> INFORMACJE DODATKOWE
					<span style="text-transform: none; font-weight: normal; font-size: 0.7em">
					<br/>W przypadku:<br/>
						- umowy spółki należy podać adres siedziby spółki (rzeczywistego ośrodka zarządzania),<br/>
						- umowy sprzedaży, gdy kupujący nie ma miejsca zamieszkania lub siedziby na terytorium Rzeczypospolitej Polskiej, należy podać miejsce zamieszkania lub siedzibę sprzedawcy, a jeżeli żadna ze stron nie ma miejsca zamieszkania lub siedziby na terytorium Rzeczypospolitej Polskiej, należy podać miejsce dokonania czynności,<br/>
						- umowy sprzedaży przedsiębiorstwa albo jego zorganizowanej części należy podać siedzibę przedsiębiorstwa albo miejsce położenia jego zorganizowanej części,<br/>
						- orzeczenia sądu, w tym polubownego, oraz ugody, jeżeli przedmiotem jest przeniesienie własności nieruchomości, prawa użytkowania wieczystego lub spółdzielczego własnościowego prawa do lokalu mieszkalnego albo użytkowego, należy podać miejsce położenia nieruchomości.
					</span>
			</h2>
			<table class="normalna">
				<tr>
					<td class="wypelniane" style="width:60%">
						<div class="opisrubryki">54. Województwo</div>
						<xsl:value-of select="pf:P_54"/>
					</td>
					<td class="wypelniane" style="width:40%">
						<div class="opisrubryki">55. Powiat</div>
						<xsl:value-of select="pf:P_55"/>
					</td>
				</tr>
			</table>
			<table class="normalna">
				<tr>
					<td class="wypelniane" style="width:20%">
						<div class="opisrubryki">56. Gmina</div>
						<xsl:value-of select="pf:P_56"/>
					</td>
					<td class="wypelniane" style="width:50%">
						<div class="opisrubryki">57. Ulica</div>
						<xsl:value-of select="pf:P_57"/>
					</td>
					<td class="wypelniane" style="width:15%">
						<div class="opisrubryki">58. Nr domu</div>
						<xsl:value-of select="pf:P_58"/>
					</td>
					<td class="wypelniane" style="width:15%">
						<div class="opisrubryki">59. Nr lokalu</div>
						<xsl:value-of select="pf:P_59"/>
					</td>
				</tr>
			</table>
			<table class="normalna">
				<tr>
					<td class="wypelniane" style="width:70%">
						<div class="opisrubryki">60. Miejscowość</div>
						<xsl:value-of select="pf:P_60"/>
					</td>
					<td class="wypelniane" style="width:30%">
						<div class="opisrubryki">61. Kod pocztowy</div>
						<xsl:value-of select="pf:P_61"/>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="InformacjaOZalacznikach">
		<xsl:param name="sekcja"/>
		<xsl:for-each select="pf:PozycjeSzczegolowe">
			<h2 class="tytul-sekcja-blok">
				<xsl:value-of select="$sekcja"/> INFORMACJA O ZAŁĄCZNIKACH</h2>
			<table class="normalna">
				<tr>
					<td class="wypelniane" style="width:30%">
						<div class="opisrubryki">62. Liczba dołączonych załączników PCC-3/A</div>
						<div class="kwota">
							<xsl:value-of select="pf:P_62"/>
						</div>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ObjasnieniaPCC3">
		<h2 class="tekst">Objaśnienia</h2>
		<h3 align="justify">
			<font size="2pt">
				<sup>1)</sup> Przez urząd, do którego adresowana jest deklaracja rozumie się urząd skarbowy, przy pomocy którego właściwy w sprawie podatku od czynności cywilnoprawnych naczelnik urzędu skarbowego wykonuje swoje zadania.
      </font>
		</h3>
		<h3 align="justify">
			<font size="2pt">
				<sup>2)</sup> Zgodnie z art. 81 ustawy z dnia 29 sierpnia 1997 r. - Ordynacja podatkowa (Dz. U. z 2023 r. poz. 2383).
      </font>
		</h3>
		<h3 align="justify">
			<font size="2pt">
				<sup>3)</sup> W przypadku umowy sprzedaży, w której nie wyodrębniono wartości rzeczy lub praw majątkowych, do których mają zastosowanie różne stawki podatku, w poz. 26 należy wpisać łączną wartość tych rzeczy lub praw majątkowych.
      </font>
		</h3>
		<h3 align="justify">
			<font size="2pt">
				<sup>4)</sup> W przypadku umowy pożyczki zwolnionej na podstawie art. 9 pkt 10 lit. b ustawy, w poz. 31 należy wpisać kwotę udzielonej pożyczki, a w poz. 32 i 33 należy wpisać 0.
      </font>
		</h3>
		<h3 align="justify">
			<font size="2pt">
				<sup>5)</sup> W przypadku ustanowienia hipoteki na zabezpieczenie wierzytelności istniejących, w poz. 40 należy wpisać kwotę zabezpieczonej wierzytelności; w przypadku ustanowienia hipoteki na zabezpieczenie wierzytelności o wysokości nieustalonej, w poz. 42 należy wpisać liczbę 19.
      </font>
		</h3>
	</xsl:template>
	<xsl:template name="PouczeniaPCC3">
		<xsl:if test="pf:Pouczenia ='1'">
			<h2 class="tekst">Pouczenia</h2>
			<h3 align="justify">
				<font size="2pt">
         Za podanie nieprawdy lub zatajenie prawdy i przez to narażenie podatku na uszczuplenie grozi odpowiedzialność przewidziana w Kodeksie karnym skarbowym.<br/>
         W przypadku niezapłacenia w obowiązującym terminie kwoty podatku od czynności cywilnoprawnych z poz. 53 lub wpłacenia jej w niepełnej wysokości, niniejsza deklaracja stanowi podstawę do wystawienia tytułu wykonawczego, zgodnie z przepisami ustawy z dnia 17 czerwca 1966 r. o postępowaniu egzekucyjnym w administracji (Dz. U. z 2023 r. poz. 2505).<br/>
				</font>
			</h3>
		</xsl:if>
		<div class="lamstrone"/>
	</xsl:template>
	<xsl:template match="*[local-name()='Naglowek']/*[local-name()='Data']">
		<span class="data">
			<span class="opisrubryki">
				<xsl:call-template name="WezNumerPozycji"/>
				<xsl:text>Data dokonania czynności  </xsl:text>
			</span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
</xsl:stylesheet>