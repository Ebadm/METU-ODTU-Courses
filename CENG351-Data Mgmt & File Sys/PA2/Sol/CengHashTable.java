import java.util.ArrayList;
import java.util.Objects;


public class CengHashTable {

	//private int bucketSize;
	private int globalDepth = 0;
	private ArrayList<CengHashRow> table = new ArrayList<>();
	public int size;
	public CengBucketList BList;



	public CengHashTable()
	{
		CengBucket cb = new CengBucket(0);
		CengHashRow hr = new CengHashRow("0", cb);
		BList = new CengBucketList();
		BList.addBucket(cb);
		table.add(hr);
		this.size = 1;
	}

	public void deletePoke(Integer pokeKey)
	{
		int i;
		int count=0;
		String Hash = calculateHash(pokeKey);
		int pos = Integer.parseInt(Hash,2);
		CengBucket bp = table.get(pos).getBucket();

		for (i = 0; i < bp.values.size(); i++) {
			if (Objects.equals(bp.values.get(i).pokeKey(), pokeKey))
				break;
		}
		bp.values.remove(i);

		for (i = 0; i < BList.bucketCount(); i++) {
			if (BList.bucketAtIndex(i).isEmpty())
				count++;
		}
		System.out.println("\"delete\": {");
		System.out.println("\t\"emptyBucketNum\": " + count);
		System.out.println("}");

	}

	public void addPoke(CengPoke poke) {
		String Hash = calculateHash(poke.pokeKey());
		int pos = Integer.parseInt(Hash,2);
		CengBucket bp = table.get(pos).getBucket();
		if (bp.pokeCount() != CengPokeKeeper.getBucketSize()) {
			bp.pokeAdd(poke);
		} else {
			while(pos != 0 && bp == table.get(pos-1).getBucket()) {
				pos--;
			}
			this.split(bp,pos);
			addPoke(poke);
		}

	}

	public void split(CengBucket bp, int pos)
	{
		ArrayList<CengPoke> container = new ArrayList<>(bp.values);
		int peerBucket = pos+(globalDepth - bp.localDepth);
		int count=0;


		while (peerBucket+1+count < table.size() && container.equals(table.get(peerBucket+count+1).getBucket().values)) {
			count++;
		}



		bp.values.clear();
		int localdepth = ++bp.localDepth;


		if(localdepth > globalDepth) {
			Enlarge();
			peerBucket = 2*pos+1;
		}

		table.get(peerBucket).bucket = new CengBucket(localdepth);
		BList.addBucket(table.get(peerBucket).bucket);

		while (count != 0) {
			table.get(peerBucket+1).bucket = table.get(peerBucket).bucket;
			count--;
		}


		for (CengPoke cengPoke : container) {
			addPoke(cengPoke);
		}

	}

	public void Enlarge()
	{
		if (table.size() == 1){
			CengBucket cb = table.get(0).getBucket();
			CengHashRow hr = new CengHashRow("1" , cb);
			table.add(hr);
		}
		else {
			for (int i = 0; i < table.size(); i+=2) {
				CengBucket cb = table.get(i).getBucket();
				String hashPref = table.get(i).hashPrefix();
				table.get(i).hashPrefix = hashPref + "0";
				CengHashRow hr = new CengHashRow(hashPref + "1", cb);
				table.add(i+1,hr);
			}
		}

		globalDepth++;

	}

	public void searchPoke(Integer pokeKey)
	{
		int k=1,j=1;
		String Hash = calculateHash(pokeKey);
		int pos = Integer.parseInt(Hash,2);
		CengBucket bp = table.get(pos).getBucket();

		if (!bp.pokeInBucket(pokeKey)){
			System.out.println("\"search\": {");
			System.out.println("}");
		}
		else{
			if (bp.localDepth==this.globalDepth){
				System.out.println("\"search\": {");
				System.out.println("\t\"row\": {");
				table.get(pos).print();
				System.out.println("\t}");
				System.out.println("}");
			}
			else {
				ArrayList<CengHashRow> commonRows = new ArrayList<>();


				while (pos - j >= 0 && bp.equals(table.get(pos - j).getBucket())) {
					j++;
				}

				pos = pos + 1 - j;
				commonRows.add(table.get(pos));

				while (pos + k < table.size() && bp.equals(table.get(pos + k).getBucket())) {
					commonRows.add(table.get(pos + k));
					k++;
				}

				System.out.println("\"search\": {");
				for (int i = 0; i < commonRows.size(); i++) {
					System.out.println("\t\"row\": {");
					commonRows.get(i).print();
					if (i + 1 >= commonRows.size())
						System.out.println("\t}");
					else
						System.out.println("\t},");
				}
				System.out.println("}");
			}
		}
	}
	
	public void print()
	{
		System.out.println("\"table\": {");
		for (int i = 0; i < table.size(); i++) {
			System.out.println("\t\"row\": {");
			table.get(i).print();
			if (i+1 >= table.size())
				System.out.println("\t}");
			else
				System.out.println("\t},");
		}
		System.out.println("}");
	}

	// GUI-Based Methods
	// These methods are required by GUI to work properly.
	
	public int prefixBitCount()
	{
		return globalDepth;
	}
	
	public int rowCount()
	{
		return table.size();
	}
	
	public CengHashRow rowAtIndex(int index)
	{
		return table.get(index);
	}
	
	// Own Methods

	public String calculateHash(int val) {
		int hashed = val % CengPokeKeeper.getHashMod();
		int digits = this.globalDepth;
		if (digits == 0) {
			return "0";
		}
		int max_globaldep = (int)(Math.log(CengPokeKeeper.getHashMod()) / Math.log(2));
		String bin = Integer.toBinaryString(hashed);
		while (bin.length() != max_globaldep){
			bin = "0" + bin;
		}
		return bin.substring(0,digits);
	}

}
