import java.util.ArrayList;

public class CengBucket {

	private Boolean visited;
	// GUI-Based Methods
	// These methods are required by GUI to work properly.
	public int localDepth;

	public ArrayList<CengPoke> values = new ArrayList<>();

	CengBucket(int localDepth) {
		this.localDepth = localDepth;
		this.visited = false;
	}

	public void pokeAdd(CengPoke e) {
		values.add(e);
	}

	public boolean isEmpty() {
		return (values.size() == 0);
	}

	public boolean pokeInBucket(int pokeKey){
		boolean flag = false;
		for (CengPoke value : values) {
			if (value.pokeKey() == pokeKey) {
				flag = true;
			}
		}
	    return flag;
	}

	public int pokeCount() {
		return values.size();
	}

	public CengPoke pokeAtIndex(int index) {

		return values.get(index);
	}

	public int getHashPrefix() {
		return this.localDepth;
	}


	public Boolean isVisited() {
		return this.visited;
	}

	// Own Methods
	public void Visited() {
		this.visited = true;
	}

	public void print() {
		System.out.println("\t\t\"bucket\": {");
		System.out.println("\t\t\t\"hashLength\": " + this.localDepth + ",");
		System.out.println("\t\t\t\"pokes\": [");
		for (int i = 0; i < values.size(); i++) {
			int key = values.get(i).pokeKey();
			String Hash = Integer.toBinaryString(key % CengPokeKeeper.getHashMod());
			int max_globaldep = (int)(Math.log(CengPokeKeeper.getHashMod()) / Math.log(2));
			while (Hash.length() != max_globaldep){
				Hash = "0" + Hash;
			}
			String pokeName = values.get(i).pokeName();
			String pokePower = values.get(i).pokePower();
			String pokeType = values.get(i).pokeType();

			System.out.println("\t\t\t\t\"poke\": {");
			System.out.println("\t\t\t\t\t\"hash\": " + Hash + ",");
			System.out.println("\t\t\t\t\t\"pokeKey\": " + key + ",");
			System.out.println("\t\t\t\t\t\"pokeName\": " + pokeName + ",");
			System.out.println("\t\t\t\t\t\"pokePower\": " + pokePower + ",");
			System.out.println("\t\t\t\t\t\"pokeType\": " + pokeType);

			if (i+1 >= values.size())
				System.out.println("\t\t\t\t}");
			else
				System.out.println("\t\t\t\t},");

		}
		System.out.println("\t\t\t]");
		System.out.println("\t\t}");
	}
}

