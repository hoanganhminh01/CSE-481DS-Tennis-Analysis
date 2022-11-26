from turtle import *

pen = Turtle()
pen2 = Turtle()
wn = Screen()
wn.setup(width=1000, height=800)


def heart():
    pen2.pensize(10)
    pen2.fillcolor('red')
    pen2.begin_fill()
    pen2.left(140)
    pen2.forward(113)
    for i in range(200):
        pen2.right(1)
        pen2.forward(1)
    pen2.left(120)
    for i in range(200):
        pen2.right(1)
        pen2.forward(1)
    pen2.forward(112)
    pen2.end_fill()


def txt():
    pen2.up()
    pen2.setpos(-74, 95)
    pen2.down()
    pen2.color('yellow')
    pen2.write("For you, Mary TNĐ", font=("Comic Sans MS", 12, "bold"))


def whale():
    pen.pensize(10)
    pen.fillcolor('blue')
    pen.begin_fill()

    pen.right(20)
    for i in range(10):
        pen.left(5)
        pen.back(20)
    for i in range(3):
        pen.left(17)
        pen.back(10)
    for i in range(10):
        pen.left(2)
        pen.back(10)
    for i in range(5):
        pen.left(15)
        pen.back(10)
    for i in range(8):
        pen.left(2)
        pen.back(20)
    for i in range(6):
        pen.right(10)
        pen.back(2)
    for i in range(8):
        pen.left(5)
        pen.back(15)
    pen.left(150)
    for i in range(5):
        pen.right(6)
        pen.back(15)
    pen.left(60)
    for i in range(40):
        pen.left(2.7)
        pen.fd(10)
    for i in range(10):
        pen.right(8)
        pen.fd(15)
    pen.right(100)
    for i in range(10):
        pen.right(8)
        pen.fd(15)
    for i in range(4):
        pen.right(2)
        pen.fd(15)
    for i in range(7):
        pen.right(10)
        pen.fd(15)
    pen.right(100)
    for i in range(8):
        pen.right(8)
        pen.fd(15)
    for i in range(5):
        pen.right(13)
        pen.fd(10)
    for i in range(10):
        pen.right(3)
        pen.fd(10)
    for i in range(5):
        pen.right(13)
        pen.fd(15)
    for i in range(15):
        pen.left(1)
        pen.fd(10)
    pen.end_fill()


whale()
heart()
txt()
pen.ht()
exitonclick()


