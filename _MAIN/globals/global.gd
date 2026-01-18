extends Node

#global enums
enum GameState {
	MAINMENU,
	PAUSED,
	PLAYING,
	GAMEOVER
}

#global vars
var Current_GameState : GameState
var Current_Level : int

#global consts
const GameSizeX = 1920
const GameSizeY = 1080
const GRAVITY = 980
const PLAYER_SPEED = 300
const LILGUY_SPEED = 50
const FRICTION = 15

#global path strings
var lilguyPath : String = "res://Characters/LilGuys.tscn"
var birbsPath : String = "res://Characters/birbs.tscn"
var sunPath : String = "res://Characters/sun.tscn"

#use subviewport with these sizes
#parent node should be subviewport container with stretch on, shrink stretch 5
#Node2D / level scenes should be children scenes to the subviewport
#this will stretch the game scene to the full 1080p res
#allows UI elements and text to be HD while game assets stay 
const SubviewportSizeX = 384 #24 16x16 tiles wide
const SubviewportSizeY = 216 #13.5 16x16 tiles tall
