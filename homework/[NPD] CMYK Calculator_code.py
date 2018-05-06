import matplotlib.pyplot as plt
import PIL

global data

# The capacity of each colors' tank (각 탱크의 기본 용량을 500ml로 잡았을 때)
def bottle(c_, m_, y_, k_):
    cyan_bottle = 500 - float(c_)
    magenta_bottle = 500 - float(m_)
    yellow_bottle = 500 - float(y_)

    #Black color needs C & M & Y to be mixed
    cyan_bottle = cyan_bottle - (k_/3)
    magenta_bottle = magenta_bottle - (k_/3)
    yellow_bottle = yellow_bottle - (k_/3)
    white_bottle = 500 - ((amount/4 - float(c_)) + (amount/4 - float(m_)) + (amount/4 - float(y_)) + (amount/4 - float(k_)))
    print('\n',"Check_Total_Left : ", cyan_bottle + magenta_bottle + yellow_bottle + white_bottle,"ml",'\n')
    print("CYAN left : ", cyan_bottle,"ml")
    print("Magenta left : ", magenta_bottle, "ml")
    print("Yellow left : ", yellow_bottle, "ml")
    print("White left : ", white_bottle, "ml")
    ##return(cyan_bottle, magenta_bottle, yellow_bottle, white_bottle) <- not using it


img_name = input("Write file name and its file name extension. (ex) FISH.jpg : ")
data = PIL.Image.open(img_name)

# Find the axis of pixel in the image
# Save the axis to each variables
def setting_axis():
    fig, ax = plt.subplots()
    ax.imshow(data, interpolation='none')
    plt.show()
    global x_axis, y_axis
    x_axis = int(input("Put X axis of the pixel : "))
    y_axis = int(input("Put Y axis of the pixel : "))

# Checks CMYK code & shows the color you choose
def check_CMYK(x_, y_):
    cmyk_im = data.convert('CMYK')
    global c, m, y, k
    c, m, y, k = cmyk_im.getpixel((x_, y_))
    example_CMYK = PIL.Image.new('CMYK', (100, 100), (c, m, y, k))
    example_CMYK.show()

# Shows CMYK code & gives operation to machine
def operate_CMYK(x_, y_):
    print("  ** The elements of the pixel ** \n",
          "=================================\n",
          "CYAN :",int(c / 255 * 100),"%\n",
          "MAGENTA :", int(m / 255 * 100),"%\n",
          "YELLOW :", int(y / 255 * 100),"%\n",
          "BLACK :", int(k / 255 * 100),"%")
    # percent_c, percent_m, percent_y, percent_k = int(c / 255), int(m / 255), int(y / 255), int(k / 255)
    global amount
    amount = int(input("How much amount you want to make? (ml) : "))
    required_c =  amount * (1/4) * float(c / 255)
    required_m =  amount * (1/4) * float(m / 255)
    required_y =  amount * (1/4) * float(y / 255)
    required_k =  amount * (1/4) * float(k / 255)
    bottle(required_c,required_m,required_y,required_k)

# Operation
def machine_operation():
    while True:
        setting_axis()
        check_CMYK(x_axis, y_axis)
        answer = input("Is this the color you want? (enter 'y' or 'n') : ")
        if answer == "y":
            break
        elif answer == "n":
            pass
        else:
            print("You wrote wrong answer. Go back to first stage.")

    operate_CMYK(x_axis, y_axis)
    print("\nProducing......\n")

machine_operation()