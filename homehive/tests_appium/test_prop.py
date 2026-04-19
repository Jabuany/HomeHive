from appium import webdriver
from appium.options.android import UiAutomator2Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from appium.webdriver.common.appiumby import AppiumBy

print("INICIO TEST EDITAR")

options = UiAutomator2Options()
options.platform_name = "Android"
options.device_name = "Android Emulator"
options.app_package = "com.example.homehive"
options.app_activity = ".MainActivity"
options.no_reset = True

driver = webdriver.Remote("http://127.0.0.1:4723", options=options)
wait = WebDriverWait(driver, 30)

print("PANTALLA EDITAR CARGADA")

# INPUT NOMBRE
nombre = wait.until(
    EC.presence_of_element_located(
        (AppiumBy.ACCESSIBILITY_ID, "input_nombre")
    )
)
nombre.clear()
nombre.send_keys("Casa editada")

# INPUT PRECIO
precio = wait.until(
    EC.presence_of_element_located(
        (AppiumBy.ACCESSIBILITY_ID, "input_precio")
    )
)
precio.clear()
precio.send_keys("5000")

print("DATOS ESCRITOS")

# BOTÓN GUARDAR
guardar = wait.until(
    EC.element_to_be_clickable(
        (AppiumBy.ACCESSIBILITY_ID, "btn_guardar")
    )
)

guardar.click()

print("EDITADO CORRECTAMENTE")

driver.quit()