extends Node

var main: Main;

#region GAME STATE =======================================================================================
var cur_character_index := 0;
var paused := false;
#endregion

#region CONSTANTS =============================================================================================
const char_dino = preload("res://scenes/characters/char_dino.tscn");
const char_bird = preload("res://scenes/characters/char_bird.tscn");
const char_elephant = preload("res://scenes/characters/char_elephant.tscn");

const CHARACTERS = [
  char_dino,
  char_elephant
  #char_bird
];

enum ABILITIES {
  JUMP,
  SING,
  CHARGE,
  DANCE,
  FIRE
}

enum SCENE_KEYS {
  MAIN_MENU,
  LEVEL_1,
}

const mainMenu = preload("res://scenes/menus/main_menu.tscn");
const level1 = preload("res://scenes/levels/world_1.tscn");

const SCENES = {
  SCENE_KEYS.MAIN_MENU: mainMenu,
  SCENE_KEYS.LEVEL_1: level1,
}
#endregion

#region FUNCTIONS ========================================================================================
func increment_character_index():
  cur_character_index += 1;
  if(cur_character_index > CHARACTERS.size() - 1):
    cur_character_index = 0;
#end increment_character_index

func get_next_character():
  increment_character_index();
  return CHARACTERS[cur_character_index].instantiate();
#end get_next_character
#endregion
