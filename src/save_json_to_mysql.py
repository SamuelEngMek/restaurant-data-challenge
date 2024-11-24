import json
import mysql.connector

# Configuração da conexão com o MySQL
db_config = {
    "host": "hostname",
    "user": "username",
    "password": "password",
    "database": "databasename"
}

# Variável que representa o caminho para o arquivo JSON.
# Este JSON simula a resposta de um endpoint de API do ERP
json_path = "src\\ERP.json"

# Função para inserir dados no banco
def insert_data(json_data):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        # Inserir restaurante
        loc_ref = json_data["locRef"]
        cursor.execute(
            "INSERT INTO Restaurants (locRef, name) VALUES (%s, %s) "
            "ON DUPLICATE KEY UPDATE name = VALUES(name)",
            (loc_ref, "Restaurant Name")
        )

        for guest_check in json_data["guestChecks"]:
            # Inserir GuestCheck
            guest_check_values = (
                guest_check["guestCheckId"], guest_check["chkNum"], guest_check["opnBusDt"], guest_check["opnUTC"],
                guest_check["opnLcl"], guest_check["clsdBusDt"], guest_check["clsdUTC"], guest_check["clsdLcl"],
                guest_check["lastTransUTC"], guest_check["lastTransLcl"], guest_check["lastUpdatedUTC"], guest_check["lastUpdatedLcl"],
                guest_check["clsdFlag"], guest_check["gstCnt"], guest_check["subTtl"], guest_check["nonTxblSlsTtl"],
                guest_check["chkTtl"], guest_check["dscTtl"], guest_check["payTtl"], guest_check["balDueTtl"],
                guest_check["rvcNum"], guest_check["otNum"], guest_check["ocNum"], guest_check["tblNum"],
                guest_check["tblName"], guest_check["empNum"], guest_check["numSrvcRd"], guest_check["numChkPrntd"], loc_ref
            )
            cursor.execute("""
                INSERT INTO GuestChecks (
                    guestCheckId, chkNum, opnBusDt, opnUTC, opnLcl, clsdBusDt, clsdUTC, clsdLcl,
                    lastTransUTC, lastTransLcl, lastUpdatedUTC, lastUpdatedLcl, clsdFlag, gstCnt, subTtl, nonTxblSlsTtl,
                    chkTtl, dscTtl, payTtl, balDueTtl, rvcNum, otNum, ocNum, tblNum, tblName, empNum, numSrvcRd,
                    numChkPrntd, locRef
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE lastUpdatedUTC = VALUES(lastUpdatedUTC)
            """, guest_check_values)

            # Inserir Taxes
            for tax in guest_check.get("taxes", []):
                tax_values = (
                    guest_check["guestCheckId"], tax["taxNum"], tax["txblSlsTtl"], tax["taxCollTtl"],
                    tax["taxRate"], tax["type"]
                )
                cursor.execute("""
                    INSERT INTO Taxes (guestCheckId, taxNum, txblSlsTtl, taxCollTtl, taxRate, type)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, tax_values)

            # Inserir DetailLines
            for detail in guest_check.get("detailLines", []):
                detail_values = (
                    detail["guestCheckLineItemId"], guest_check["guestCheckId"], detail["lineNum"], detail["dtlOtNum"],
                    detail["dtlOcNum"], detail["detailUTC"], detail["detailLcl"], detail["lastUpdateUTC"],
                    detail["lastUpdateLcl"], detail["busDt"], detail["wsNum"], detail["dspTtl"], detail["dspQty"],
                    detail["aggTtl"], detail["aggQty"], detail["chkEmpId"], detail["chkEmpNum"], detail["svcRndNum"],
                    detail["seatNum"]
                )
                cursor.execute("""
                    INSERT INTO DetailLines (
                        detailLineId, guestCheckId, lineNum, dtlOtNum, dtlOcNum, detailUTC, detailLcl,
                        lastUpdateUTC, lastUpdateLcl, busDt, wsNum, dspTtl, dspQty, aggTtl, aggQty, chkEmpId,
                        chkEmpNum, svcRndNum, seatNum
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, detail_values)

                # Inserir MenuItem relacionado à DetailLine
                menu_item = detail.get("menuItem", {})
                if menu_item:
                    menu_item_values = (
                        detail["guestCheckLineItemId"], menu_item["miNum"], menu_item["modFlag"],
                        menu_item["inclTax"], menu_item["activeTaxes"], menu_item["prcLvl"]
                    )
                    cursor.execute("""
                        INSERT INTO MenuItems (
                            detailLineId, miNum, modFlag, inclTax, activeTaxes, prcLvl
                        ) VALUES (%s, %s, %s, %s, %s, %s)
                    """, menu_item_values)

        conn.commit()
        print("Dados inseridos com sucesso!")
    except mysql.connector.Error as err:
        print(f"Erro: {err}")
    finally:
        cursor.close()
        conn.close()

# Ler JSON
with open(json_path, "r") as file:
    json_data = json.load(file)

# Inserir dados no banco
insert_data(json_data)