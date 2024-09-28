from xml.etree.ElementTree import Element, SubElement, tostring
import xml.etree.ElementTree as ET

# Function to parse XSD and create XML template
def parse_xsd_to_xml_template(xsd_file):
    tree = ET.parse(xsd_file)
    root = tree.getroot()
    namespaces = {'xs': 'http://www.w3.org/2001/XMLSchema'}
    
    # Create the root of the XML template based on XSD
    xml_root = Element("Deklaracja", {
        "xmlns": "http://crd.gov.pl/wzor/2023/12/13/13064/",
        "xmlns:etd": "http://crd.gov.pl/wzor/2022/09/13/12473/",
        "xmlns:tns": "http://crd.gov.pl/wzor/2023/12/13/13064/",
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation": "http://crd.gov.pl/wzor/2023/12/13/13064/ schemat.xsd"
    })
    
    # Iterate through the XSD elements to create corresponding XML elements
    for element in root.findall('.//xs:element', namespaces):
        element_name = element.get('name')
        min_occurs = element.get('minOccurs', '1')  # Default is 1
        max_occurs = element.get('maxOccurs', '1')  # Default is 1
        
        # Add the element to the XML template
        xml_element = SubElement(xml_root, element_name)
        
        # Handle optional fields by leaving them empty
        if min_occurs == '0':
            xml_element.text = ""
        else:
            xml_element.text = "PLACEHOLDER"  # Add placeholder text for required fields

    return xml_root

# Convert the ElementTree to a string
def convert_to_string(xml_element):
    return tostring(xml_element, encoding='unicode')

# Path to your XSD file
xsd_path = 'input/schemat.xsd'

# Parse the XSD and generate the XML template
xml_template = parse_xsd_to_xml_template(xsd_path)

# Convert the generated XML to a string
xml_template_str = convert_to_string(xml_template)

# Display the generated XML template
#print(xml_template_str)

# Function to save the XML template to a file
def save_xml_to_file(xml_template_str, file_path):
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(xml_template_str)

# Save the generated XML template to a file
xml_file_path = '/output/template.xml'
save_xml_to_file(xml_template, xml_file_path)

xml_file_path  # Returning the path to the saved file
