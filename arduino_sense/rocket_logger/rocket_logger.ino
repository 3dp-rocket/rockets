// https://www.arduino.cc/en/Guide/NANO33BLESense
/*
 *  The circuit:
   SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13
 ** CS - pin 10 
 * 
 * Attach optional led with resistor to pin status_led (8)

 */
#include <Arduino_LPS22HB.h>
#include <Arduino_LSM9DS1.h>   
#include <Arduino_APDS9960.h>  // color, gestures
#include <Arduino_HTS221.h>

#include <SPI.h>
#include <SD.h>

// buffer size for data we will write to the SDcard
#define BUFFER_SIZE 2048

// file name to use for writing
String filename;

const int chipSelect = 10;
byte status_led = A0;

File dataFile;

// string to buffer output
String buffer;

enum States {
  warmup,
  waiting_for_event,
  recording,
  done
};

States state;

struct SensorData {
  float pressure=0;
  float ax, ay, az = 0; // accelerometer
  bool accel_error;
  
  float gx, gy, gz = 0; // gyro
  bool gyro_error;
  
  float mx, my, mz = 0;  // magnetometer
  bool magnetometer_error;

  int r,g,b = 0;  // color

  float temperature=0;
  float humidity=0;

  
} signals, previous_signals;


uint16_t count_files(File dir) {

  uint16_t count = 0;

  while (true) {

    File entry =  dir.openNextFile();
    if (! entry) {
      // no more files
      break;
    }
    count++;
  }
  
  return count;
}



void setup() {
  
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  delay(1000);
  //while (!Serial) {
  //  ; // wait for serial port to connect. Needed for native USB port only
  //}

  if (!BARO.begin()) {
    Serial.println("Failed to initialize pressure sensor!");
  }
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
  }

  if (!APDS.begin()) {
    Serial.println("Error initializing APDS9960 (color, gesture) sensor!");
  }

  if (!HTS.begin()) {
    Serial.println("Failed to initialize humidity temperature sensor!");
  }
  
  Serial.println("Initializing SD card...");

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    while (1);
  }

  // generate new file name
  Serial.println("Generating new file name");
  File root = SD.open("/");
  uint16_t count = count_files(root);
  filename = String("data")+String(count) + ".csv";
  root.close();
  Serial.print("file name:");
  Serial.println(filename);
  
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  dataFile = SD.open(filename, FILE_WRITE);
  if (!dataFile) {
    Serial.print("error opening ");
    Serial.println(filename);
    while (1);
  }

  Serial.println("SD card initialized.");

  // reserve 2kB for String used as a buffer
  buffer.reserve(BUFFER_SIZE);

  // set LED pin to output, used to blink when writing
  pinMode(status_led, OUTPUT);
  digitalWrite(status_led, LOW);

  state = warmup;

}

// time since last update in micros
unsigned long next_update = 0;
uint16_t num_samples = 0;
uint16_t loop_count  = 0;

void read_sensors()
{

  signals.pressure = BARO.readPressure(KILOPASCAL);  // PSI, MILLIBAR, KILOPASCAL
  
  if (IMU.accelerationAvailable()) {
        IMU.readAcceleration(signals.ax, signals.ay, signals.az);
        signals.accel_error = false;
  }
  else signals.accel_error = true;

  if (IMU.gyroscopeAvailable()) {
        IMU.readGyroscope(signals.gx, signals.gy, signals.gz);
        signals.gyro_error = false;
  } else signals.gyro_error = true;

  if (IMU.magneticFieldAvailable()) {
        IMU.readMagneticField(signals.mx, signals.my, signals.mz);
        signals.magnetometer_error = false;
  } else signals.magnetometer_error = true;


  if (APDS.colorAvailable()) {
    APDS.readColor(signals.r, signals.g, signals.b);
  }

  signals.temperature = HTS.readTemperature();
  signals.humidity = HTS.readHumidity();
  
}

#define PRESSURE_THRESHOLD 0.2
#define ACCEL_THRESHOLD 1.1
#define GYRO_THRESHOLD 20

bool trigger() {

    
    if (abs(previous_signals.pressure - signals.pressure)> PRESSURE_THRESHOLD)  {  // aprox: 15 meters change
      Serial.println("pressure:");
      Serial.print(previous_signals.pressure);
      Serial.print(" ");
      Serial.println(signals.pressure);
      return true;
    }
     
    if ((abs(previous_signals.ax - signals.ax)>ACCEL_THRESHOLD) || (abs(previous_signals.ay - signals.ay)>ACCEL_THRESHOLD) || (abs(previous_signals.az - signals.az)>ACCEL_THRESHOLD)) {
      Serial.println("Accel");
      Serial.println(previous_signals.ax);
      Serial.print(" ");
      Serial.println(signals.ax);

      Serial.print(previous_signals.ay);
      Serial.print(" ");
      Serial.println(signals.ay);

      Serial.print(previous_signals.az);
      Serial.print(" ");
      Serial.println(signals.az);
      return true;
    }


    if ((abs(previous_signals.gx - signals.gx)>GYRO_THRESHOLD) || (abs(previous_signals.gy - signals.gy)>GYRO_THRESHOLD) || (abs(previous_signals.gz - signals.gz)>GYRO_THRESHOLD)) {
      Serial.println("Gyro");
      Serial.println(previous_signals.gx);
      Serial.print(" ");
      Serial.println(signals.gx);

      Serial.print(previous_signals.gy);
      Serial.print(" ");
      Serial.println(signals.gy);

      Serial.print(previous_signals.gz);
      Serial.print(" ");
      Serial.println(signals.gz);
      return true;
    }

  return false;
  
}

void write_header()
{
  char header[] = "time\tpressure\tax\tay\taz\tgyro_x\tgyro_y\tgyro_z\tmx\tmy\tmz\tr\tg\tb\ttemperature\thumidity";
  dataFile.println(header);

}
bool record_signals()
{
    if (buffer.length()>BUFFER_SIZE)
    {
      // does this work?
      Serial.println("Buffer is full");
      return false;
    }
    
    // Append data to buffer
    buffer += String(micros());
    buffer += String('\t');
    buffer += String(signals.pressure);
    buffer += String('\t');
  
    buffer += String(signals.ax);
    buffer += String('\t');
    buffer += String(signals.ay);
    buffer += String('\t');
    buffer += String(signals.az);
    buffer += String('\t');
  
    buffer += String(signals.gx);
    buffer += String('\t');
    buffer += String(signals.gy);
    buffer += String('\t');
    buffer += String(signals.gz);
    buffer += String('\t'); 
    
    buffer += String(signals.mx);
    buffer += String('\t');
    buffer += String(signals.my);
    buffer += String('\t');
    buffer += String(signals.mz);
    buffer += String('\t');

    buffer += String(signals.r);
    buffer += String('\t');
    buffer += String(signals.g);
    buffer += String('\t');
    buffer += String(signals.b);
    buffer += String('\t');
    
    buffer += String(signals.temperature);
    buffer += String('\t');
    buffer += String(signals.humidity);

    

    buffer += "\r\n";
    
    // check if the SD card is available to write data without blocking
    // and if the buffered data is enough for the full chunk size
    unsigned int chunkSize = dataFile.availableForWrite();
    if (chunkSize && buffer.length() >= chunkSize) {
      // write to file and blink LED
      digitalWrite(status_led, HIGH);
      dataFile.write(buffer.c_str(), chunkSize);
      digitalWrite(status_led, LOW);
  
      // remove written data from buffer
      buffer.remove(0, chunkSize);
    }

  return true;
  
}
void loop() {

  read_sensors();

  switch(state) {
    case warmup:

      digitalWrite(status_led, LOW);
      
      if (loop_count>1000) {
        Serial.println("warmed up-waiting for event");
        state = waiting_for_event;
        previous_signals = signals;
        write_header();
      }
      else {
        if (loop_count % 100 == 0) {
          digitalWrite(status_led, HIGH);
          Serial.print("warmup ");  
          Serial.println(loop_count);
        }
      }
            
      delay(10);
      break;

    case waiting_for_event:
      digitalWrite(status_led, HIGH);
      if (trigger()) {
        state=recording;
        next_update = 0;
        digitalWrite(status_led, LOW);
      } 
      else 
        delay(1);
        
      break;
    
    case (recording):
      if (micros() > next_update) {
        record_signals();
        next_update = micros() + 1000;
        num_samples++;

          if (num_samples % 100 == 0) {
            Serial.print("Number of samples: ");
            Serial.println(num_samples);
          }
  
          if (num_samples > 40000){
            dataFile.close();
            state = done;
            Serial.println("collected more than 40000 samples."); 
          }
      }
      else 
        delay(1);
      
      break;
      
    default:
      delay(10);
      break;
  }

  
  loop_count++;

}
