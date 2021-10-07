extends Node

signal PlayerFuelLevelChanged(new_level)
signal PlayerTookDamage(areas_are_healthy)
signal PlayerPickedUpPower(power)
signal PlayerMovementSpeedChanged(new_speed)
signal PlayerBoostStarted()
signal PlayerBoostEnded()
signal ShipWasDestroyed()
signal GameEndedPlayer(stats)
signal GameEndedOdometer(value)

signal StartGame()

signal DifficultyIncreased()

signal PickupAcquired(pickup_type, value)
