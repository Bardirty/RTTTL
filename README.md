# How to Begin

1. **Run DOSBox** with manually installed TASM and `make`.

2. **Clone the repository** into your home virtual directory.

3. **Navigate to the project directory:**
   ```
   cd rtttl
   ```

4. **Write your melody** in RTTTL language and save it as a text file in the `\music\` directory.
   
   Example:
   ```
   my_melody:d=4,o=5,b=100:c,c,a,a,g,g,c
   ```

5. **Build the project** using `make`:
   ```
   make
   ```
   
   If you've already built the project, clean old build files with:
   ```
   make clean
   ```
   Then rebuild the project:
   ```
   make
   ```

6. **Run the program** by providing the name of your text file next to the program name:
   ```
   main.exe file_name.txt
   ```
   
   **Note:** In older versions, you had to include the path (e.g., `music\file_name.txt`), but now you can simply write the file name (with `.txt`) as long as it is stored in the `\music\` directory.

7. **Listen and enjoy** 🎵😊

---

2025, Bardirty

