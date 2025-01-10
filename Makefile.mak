# Компилятор и линкер
ASM = tasm
LINKER = tlink

# Флаги для ассемблера и линкера
ASMFLAGS = /zi /ml /i.\inc
LINKERFLAGS = 

# Исполняемый файл
OUTPUT = main.exe

# Исходные файлы и объектные файлы
SRC_FILES = main.asm src\note_f.asm src\sp_c.asm
OBJ_FILES = main.obj src\note_f.obj src\sp_c.obj

# Правило по умолчанию
all: $(OUTPUT)

# Сборка исполняемого файла
$(OUTPUT): $(OBJ_FILES)
	@echo ==== Linking $(OUTPUT)... ====
	$(LINKER) $(LINKERFLAGS) $(OBJ_FILES), $(OUTPUT);

# Сборка объектного файла main.asm
main.obj: main.asm
	@echo ---- Compiling main.asm ----
	$(ASM) $(ASMFLAGS) main.asm

# Сборка объектного файла src\note_f.asm
src\note_f.obj: src\note_f.asm
	@echo ---- Compiling src\note_f.asm ----
	$(ASM) $(ASMFLAGS) src\note_f.asm
	@move note_f.obj src\note_f.obj >nul


# Сборка объектного файла src\sp_c.asm
src\sp_c.obj: src\sp_c.asm
	@echo ---- Compiling src\sp_c.asm ----
	$(ASM) $(ASMFLAGS) src\sp_c.asm
	@move sp_c.obj src\sp_c.obj >nul


# Очистка временных файлов
clean:
	@echo Cleaning up intermediate files...
	@if exist *.obj del /q *.obj
	@if exist src\*.obj del /q src\*.obj
	@if exist $(OUTPUT) del /q $(OUTPUT)
	@if exist *.map del /q *.map
	@echo Cleanup complete.
	
	
	
