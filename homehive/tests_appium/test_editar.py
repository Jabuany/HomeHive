from appium import webdriver
from appium.options.android import UiAutomator2Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from appium.webdriver.common.appiumby import AppiumBy
import time

print("INICIO TEST")

# ---------------- CONFIG ----------------
options = UiAutomator2Options()
options.platform_name = "Android"
options.device_name = "Android Emulator"
options.app_package = "com.example.homehive"
options.app_activity = ".MainActivity"
options.no_reset = True
options.new_command_timeout = 300

driver = webdriver.Remote("http://127.0.0.1:4723", options=options)
wait = WebDriverWait(driver, 30)

print("DRIVER INICIADO")

# ---------------- LOGIN ----------------
inputs = wait.until(
    EC.presence_of_all_elements_located(
        (By.CLASS_NAME, "android.widget.EditText")
    )
)

print("INPUTS ENCONTRADOS:", len(inputs))

# EMAIL
inputs[0].click()
inputs[0].clear()
inputs[0].send_keys("apt10312@gmail.com")
print("EMAIL ESCRITO")

# PASSWORD
inputs[1].click()
inputs[1].clear()
inputs[1].send_keys("123456")
print("PASSWORD ESCRITO")

# LOGIN
wait.until(
    EC.element_to_be_clickable((By.CLASS_NAME, "android.widget.Button"))
).click()

print("LOGIN CLICKEADO")

# ---------------- ESPERAR HOME ----------------

print("HOME CARGADO")


# ---------------- FIN ----------------
driver.quit()