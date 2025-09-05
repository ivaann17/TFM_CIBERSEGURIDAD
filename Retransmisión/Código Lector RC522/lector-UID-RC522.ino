#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN 9
#define SS_PIN 10
MFRC522 mfrc522(SS_PIN, RST_PIN);

uint8_t ActualUID[10] = {0};

void setup() {
  Serial.begin(9600);
  SPI.begin();
  mfrc522.PCD_Init();
  if (mfrc522.PCD_PerformSelfTest()) {
    Serial.println(F("Lector RC522 conectado correctamente."));
  } else {
    Serial.println(F("Error: No se detecta el lector RC522."));
  }
}

void loop() {
  if (mfrc522.PICC_IsNewCardPresent()) {
    if (mfrc522.PICC_ReadCardSerial()) {
      Serial.print(F("UID de la tarjeta:"));
      for (uint8_t i = 0; i < mfrc522.uid.size && i < sizeof(ActualUID); i++) {
        Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
        Serial.print(mfrc522.uid.uidByte[i], HEX);
        ActualUID[i] = mfrc522.uid.uidByte[i];
        
      }
      mfrc522.PICC_HaltA();
    }
  }
}
