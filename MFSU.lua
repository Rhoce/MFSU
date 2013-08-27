local monitor = peripheral.wrap("top")
local net = peripheral.wrap("left")
term.redirect(monitor)

couleurMFSU2 = colors.lightBlue
couleurMFSU3 = colors.magenta
couleurMFSU4 = colors.white
couleurMFSU5 = colors.orange
statutMFSU2 = false
statutMFSU3 = false
statutMFSU4 = false
statutMFSU5 = false
signalComplet = 0
clicX = 0
clicY = 0
secondes = 60

function Capacite(MFSU)
  Cap = net.callRemote(MFSU, "getCapacity")
  return Cap
end

function Charge(MFSU)
  Cha = net.callRemote(MFSU, "getStored")
  if Cha > 10000000 then
    Cha = 10000000
  end
  Cha = math.abs(Cha)
  return Cha
end

function TrameEcran()
monitor.clear()
ecr = paintutils.loadImage("screen")
paintutils.drawImage(ecr, 1, 1)
end

function CouleurTexteMFSU(idMFSU)
  couleur = colors.red
  if idMFSU = "MFSU 2" and statutMFSU2 then
    couleur = colors.lime
  end
  if idMFSU = "MFSU 3" and statutMFSU3 then
    couleur = colors.lime
  end
  if idMFSU = "MFSU 4" and statutMFSU4 then
    couleur = colors.lime
  end
  if idMFSU = "MFSU 5" and statutMFSU5 then
    couleur = colors.lime
  end
  return couleur
end

function CaseMFSU(x, y, idMFSU, idBatbox)
    monitor.setCursorPos(x + math.ceil((23 / 2) - (idMFSU:len() / 2)) - 1, y + 1)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(CouleurTexteMFSU(idMFSU))
    monitor.write(idMFSU)
    Charg = " "..Charge(idBatbox).." "
    monitor.setCursorPos(x + math.ceil((23 / 2) - (Charg:len() / 2)) - 1, y + 3)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(CouleurTexteMFSU(idMFSU))
    monitor.write(Charg)
end

function ClicMFSU(x, y)
  if x >= 52 and x <= 74 and y >= 6 and y <= 12 then
    if statutMFSU2 == false then
      statutMFSU2 = true
    else
      statutMFSU2 = false
    end
  end
  if x >= 77 and x <= 99 and y >= 6 and y <= 12 then
    if statutMFSU3 == false then
      statutMFSU3 = true
    else
      statutMFSU3 = false
    end
  end
  if x >= 27 and x <= 49 and y >= 14 and y <= 20 then
    if statutMFSU4 == false then
      statutMFSU4 = true
    else
      statutMFSU4 = false
    end
  end
  if x >= 52 and x <= 74 and y >= 14 and y <= 20 then
    if statutMFSU5 == false then
      statutMFSU5 = false
    else
      statutMFSU5 = true
    end
  end
  signalComplet = 0
  if statutMFSU2 == true then
    signalComplet = signalComplet + couleurMFSU2
  end
  if statutMFSU3 == true then
    signalComplet = signalComplet + couleurMFSU3
  end
  if statutMFSU4 == true then
    signalComplet = signalComplet + couleurMFSU4
  end
  if statutMFSU5 == true then
    signalComplet = signalComplet + couleurMFSU5
  end
  rs.setBundledOutput("bottom", signalComplet)  
end

function HeureMontreal()
  if secondes == 60 then
    monitor.setCursorPos(4, 3)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.black)
    monitor.write("Montreal :"..http.get("http://www.timeapi.org/est/in+one+hour?format=%20%25I:%25M").readAll().." ")
    secondes = 0
  end
end

function HeureMinecraft()
  monitor.setCursorPos(70, 3)
  monitor.setBackgroundColor(colors.white)
  monitor.setTextColor(colors.black)
  monitor.write("Minecraft : "..textutils.formatTime(os.time(), true).." ")
end

monitor.setTextScale(0.5)
TrameEcran()

repeat
  os.startTimer(1)
  event, p1, p2, p3 = os.pullEvent()
  if event == "monitor_touch" then
    ClicMFSU(p2, p3)
  end
  if event=="timer" then
    if secondes == 60 then
      HeureMontreal()
    end
    HeureMinecraft()
    CaseMFSU(27, 6, "MFSU Solaire", "batbox_1")
    CaseMFSU(52, 6, "MFSU 2", "batbox_2")
    CaseMFSU(77, 6, "MFSU 3", "batbox_3")
    CaseMFSU(27, 14, "MFSU 4", "batbox_4")
    CaseMFSU(52, 14, "MFSU 5", "batbox_5")
    secondes = secondes + 0.5
  end
until event=="char" and p1=="x"

term.restore()
