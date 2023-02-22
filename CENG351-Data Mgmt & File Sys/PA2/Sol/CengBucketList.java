import java.util.ArrayList;


public class CengBucketList {

	ArrayList<CengBucket> blist;


	public CengBucketList()
	{

		this.blist = new ArrayList<>();
	}

	public void deletePoke(Integer pokeKey)
	{
		// TODO: Empty Implementation
	}

	public void addBucket(CengBucket bp)
	{
		blist.add(bp);
	}

	public void addPoke(CengPoke poke)
	{
		// TODO: Empty Implementation
	}
	
	public void searchPoke(Integer pokeKey)
	{
		// TODO: Empty Implementation
	}
	
	public void print()
	{
		System.out.print("Bucket List Printing");
		for (CengBucket cengBucket : blist) {
			System.out.print("HashPrefix" + cengBucket.getHashPrefix());
		}
	}
	
	// GUI-Based Methods
	// These methods are required by GUI to work properly.
	
	public int bucketCount()
	{
		return this.blist.size();
	}
	
	public CengBucket bucketAtIndex(int index)
	{

		return this.blist.get(index);
	}
	
	// Own Methods


}
