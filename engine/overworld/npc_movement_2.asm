FreezeEnemyTrainerSprite::
	ld a, [wCurMap]
	cp POKEMON_TOWER_7F
	ret z ; the Rockets on Pokemon Tower 7F leave after battling, so don't freeze them
	ld hl, RivalIDs
	ld a, [wEngagedTrainerClass]
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .notRival
	cp b
	ret z ; the rival leaves after battling, so don't freeze him
	jr .loop
.notRival
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	jp SetSpriteMovementBytesToFF

RivalIDs:
	db OPP_RIVAL1
	db OPP_RIVAL2
	db OPP_RIVAL3
	db -1 ; end

RunNPCMovementScript::
	ld hl, wd736
	bit 0, [hl]
	res 0, [hl]
	jr nz, .playerStepOutFromDoor
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret z
	dec a
	add a
	ld d, 0
	ld e, a
	ld hl, .NPCMovementScriptPointerTables
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wNPCMovementScriptBank]
	call BankswitchCommon
	ld a, [wNPCMovementScriptFunctionNum]
	call CallFunctionInTable
	pop af
	call BankswitchCommon
	ret

.NPCMovementScriptPointerTables
	dw PalletMovementScriptPointerTable
	dw PewterMuseumGuyMovementScriptPointerTable
	dw PewterGymGuyMovementScriptPointerTable
.playerStepOutFromDoor
	farjp PlayerStepOutFromDoor
