extends Node


#signal UpgradeStats(typeOfPowerup, ammount, handName)

#signal EnemyDied(global_position_of_enemy, raw_score_to_give : int)

signal GameStart()
signal GameEnd(GameWon : bool)
signal TakeDamage()
signal RedDeath()

signal SaveGame()
signal LoadGame()
signal DataLoaded()
