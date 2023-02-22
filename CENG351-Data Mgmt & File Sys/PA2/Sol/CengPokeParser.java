import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Objects;

public class CengPokeParser {

	public static ArrayList<CengPoke> parsePokeFile(String filename) {
		ArrayList<CengPoke> pokeList = new ArrayList<CengPoke>();

		// You need to parse the input file in order to use GUI tables.
		// TODO: Parse the input file, and convert them into CengPokes
		FileReader input = null;
		try {
			input = new FileReader(filename);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		try (BufferedReader br = new BufferedReader(input)) {
			String myLine = null;

			while ((myLine = br.readLine()) != null) {
				String[] splited = myLine.split("\\s+");
				CengPoke poke = new CengPoke(Integer.parseInt(splited[1]), splited[2], splited[3], splited[4]);
				pokeList.add(poke);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		return pokeList;
	}
	
	public static void startParsingCommandLine() throws IOException
	{
		// TODO: Start listening and parsing command line -System.in-.
		// There are 5 commands:
		// 1) quit : End the app. Print nothing, call nothing.
		// 2) add : Parse and create the poke, and call CengPokeKeeper.addPoke(newlyCreatedPoke).
		// 3) search : Parse the pokeKey, and call CengPokeKeeper.searchPoke(parsedKey).
		// 4) delete: Parse the pokeKey, and call CengPokeKeeper.removePoke(parsedKey).
		// 5) print : Print the whole hash table with the corresponding buckets, call CengPokeKeeper.printEverything().

		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		while (true) {
			String inp = reader.readLine();
			String[] splited = inp.split("\\s+");
			splited[0] = splited[0].toLowerCase();
			if (Objects.equals(splited[0], "quit")){
				break;
			}
			else if (Objects.equals(splited[0], "add")){
				CengPoke newlyCreatedPoke = new CengPoke(Integer.parseInt(splited[1]), splited[2], splited[3], splited[4]);
				CengPokeKeeper.addPoke(newlyCreatedPoke);
			}
			else if (Objects.equals(splited[0], "delete")){
				CengPokeKeeper.deletePoke(Integer.parseInt(splited[1]));
			}
			else if (Objects.equals(splited[0], "search")){
				CengPokeKeeper.searchPoke(Integer.parseInt(splited[1]));
			}
			else if (Objects.equals(splited[0], "print")){
				CengPokeKeeper.printEverything();
			}

		}

		// Commands (quit, add, search, print) are case-insensitive.
	}
}
