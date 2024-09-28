from xml.etree import ElementTree as ET

# Parse the XSD and XSL files
xsd_path = 'input/schemat.xsd'
xsl_path = 'input/styl.xsl'

# Function to parse XSD file and extract elements and attributes
def parse_xsd(file_path):
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Define the namespaces
    namespaces = {'xs': 'http://www.w3.org/2001/XMLSchema'}

    fields = []

    # Iterate through all elements to extract relevant field names and types
    for element in root.findall('.//xs:element', namespaces):
        field_name = element.get('name')
        field_type = element.get('type')
        fields.append((field_name, field_type))
    
    return fields

# Parse XSD file
xsd_fields = parse_xsd(xsd_path)

# Display parsed XSD fields
print(xsd_fields)
