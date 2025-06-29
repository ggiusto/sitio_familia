import csv
from members.models import Member
from datetime import datetime

def parse_date(date_str):
    if date_str:
        try:
            return datetime.strptime(date_str, "%Y-%m-%d").date()
        except ValueError:
            return None
    return None

with open('miembros.csv', newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        member = Member.objects.create(
            first_name=row['first_name'],
            last_name_paterno=row['last_name_paterno'],
            last_name_materno=row['last_name_materno'],
            apodo=row['apodo'],
            birth_date=parse_date(row['birth_date']),
            fallecimiento_date=parse_date(row['fallecimiento_date']),
            lugar_nacimiento=row['lugar_nacimiento'],
            estudios=row['estudios'],
            ocupación=row['ocupación'],
            relationship=row['relationship'],
            padrino_de_bautismo=row['padrino_de_bautismo'],
            madrina_de_bautismo=row['madrina_de_bautismo'],
            correomail=row['correomail'],
            phone_number=row['phone_number'],
            address=row['address'],
            whatsapp=row['whatsapp'],
            facebook=row['facebook'],
            linkedin=row['linkedin'],
        )
        print(f"Miembro importado: {member}")
